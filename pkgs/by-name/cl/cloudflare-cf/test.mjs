import assert from "node:assert/strict";
import { execFile } from "node:child_process";
import { once } from "node:events";
import { createServer } from "node:http";
import { createRequire } from "node:module";
import { dirname, join, resolve } from "node:path";
import { promisify } from "node:util";

const [binary, version, packagePath] = process.argv.slice(2);
const execFileAsync = promisify(execFile);
const environment = {
  ...process.env,
  CF_SEND_TELEMETRY: "false",
  DO_NOT_TRACK: "1",
  XDG_CONFIG_HOME: resolve("config"),
  CLOUDFLARE_REGISTRY_PATH: resolve("registry"),
};

function run(args, executable = binary, extraEnvironment = {}) {
  return execFileAsync(executable, args, {
    env: { ...environment, ...extraEnvironment },
    encoding: "utf8",
    timeout: 45000,
    killSignal: "SIGKILL",
  });
}

const requireCli = createRequire(join(packagePath, "lib/cloudflare-cf/package.json"));
const requireMiniflare = createRequire(requireCli.resolve("miniflare"));
assert.match((await run(["--version"], requireMiniflare("workerd").default)).stdout, /^workerd /);

const sharp = requireMiniflare("sharp");
const image = await sharp({
  create: { width: 1, height: 1, channels: 3, background: "red" },
}).png().toBuffer();
assert.deepEqual([...await sharp(image).raw().toBuffer()], [255, 0, 0]);
assert.equal(requireCli("blake3-wasm").hash("").toString("hex"),
  "af1349b9f5f9a1a6a0404dea36dcc9499bcb25c9adc112b7cc9a93cae41f3262");
console.log("Native workerd, sharp image conversion, and BLAKE3 WASM work");

for (const executable of [binary, join(dirname(binary), "cloudflare")]) {
  const result = await run(["--version"], executable);
  assert.ok((result.stdout + result.stderr).includes(version));
}
console.log("Both executable names report the expected version");

const matches = JSON.parse((await run(["cli", "search", "create a DNS record"])).stdout);
assert.equal(matches[0].command, "cf dns records create");
const schema = JSON.parse((await run(["schema", "zones", "create"])).stdout);
assert.equal(schema.httpMethod, "POST");
assert.equal(schema.path, "/zones");
const completions = (await run(["complete", "--", "zones", "c"])).stdout.split("\n");
assert.ok(completions.some((line) => line.split("\t")[0] === "create"));
console.log("Command search, schema metadata, and completion candidates work");

// Local KV/D1 commands can hang during shutdown in this upstream release.
// https://github.com/cloudflare/cf/issues/25
// https://github.com/cloudflare/cf/issues/64
// Their native dependencies are exercised directly above.
const requests = [];
const zones = [{ id: "nixpkgs-zone", name: "example.test" }];
const server = createServer((request, response) => {
  requests.push({ method: request.method, url: request.url, headers: request.headers });
  response.writeHead(200, { "Content-Type": "application/json" });
  response.end(JSON.stringify({
    success: true,
    errors: [],
    messages: [],
    result: zones,
    result_info: { page: 1, per_page: 20, count: 1, total_count: 1 },
  }));
});
server.listen(0, "127.0.0.1");
await once(server, "listening");
try {
  const baseUrl = `http://127.0.0.1:${server.address().port}/client/v4`;
  const result = await run(["zones", "list", "--name", "example.test"], binary, {
    CLOUDFLARE_API_TOKEN: "nixpkgs-test-token",
    CLOUDFLARE_API_BASE_URL: baseUrl,
  });
  assert.deepEqual(JSON.parse(result.stdout), zones);
  assert.equal(requests.length, 1);
  assert.equal(requests[0].method, "GET");
  const url = new URL(requests[0].url, baseUrl);
  assert.equal(url.pathname, "/client/v4/zones");
  assert.equal(url.searchParams.get("name"), "example.test");
  assert.equal(requests[0].headers.authorization, "Bearer nixpkgs-test-token");
} finally {
  await promisify(server.close.bind(server))();
}
console.log("API commands send the expected authenticated request to a local test server");
