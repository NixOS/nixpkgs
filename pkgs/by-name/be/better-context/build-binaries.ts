import { $ } from "bun";
import solidPlugin from "@opentui/solid/bun-plugin";

const targetArg = process.argv[2];
const versionArg = process.argv[3];

if (!targetArg || !versionArg) {
  console.error("Usage: build-binaries.ts <target> <version>");
  process.exit(1);
}

const allTargets = [
  "bun-linux-x64",
  "bun-linux-arm64",
  "bun-darwin-x64",
  "bun-darwin-arm64",
] as const;

type Target = (typeof allTargets)[number];

const outputNames: Record<Target, string> = {
  "bun-linux-x64": "btca-linux-x64",
  "bun-linux-arm64": "btca-linux-arm64",
  "bun-darwin-x64": "btca-darwin-x64",
  "bun-darwin-arm64": "btca-darwin-arm64",
};

function isValidTarget(target: string): target is Target {
  return allTargets.includes(target as Target);
}

async function main() {
  if (!isValidTarget(targetArg)) {
    console.error(`Invalid target: ${targetArg}`);
    console.error(`Valid targets: ${allTargets.join(", ")}`);
    process.exit(1);
  }

  const target = targetArg;
  const version = versionArg;

  await $`mkdir -p dist`;

  const outfile = `dist/${outputNames[target]}`;
  console.log(`Building ${target} -> ${outfile} (v${version})`);

  const result = await Bun.build({
    entrypoints: ["src/index.ts"],
    target: "bun",
    plugins: [solidPlugin],
    define: {
      __VERSION__: `"${version}"`,
    },
    compile: {
      target,
      outfile,
      autoloadBunfig: false,
    },
  });

  if (!result.success) {
    console.error(`Build failed for ${target}:`, result.logs);
    process.exit(1);
  }

  console.log("Done building");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
