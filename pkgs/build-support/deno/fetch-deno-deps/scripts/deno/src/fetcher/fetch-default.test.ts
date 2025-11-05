import type { Hash, HashString } from "../types.d.ts";
import { normalizeHashToSRI } from "./fetch-default.ts";

export function assertEq(a: any, b: any, msg?: string) {
  function throwNow() {
    const aString = typeof a === "object" ? JSON.stringify(a, null, 2) : a;
    const bString = typeof b === "object" ? JSON.stringify(b, null, 2) : b;
    const _msg = `Assertion failed:
"${aString}"
  ===
"${bString}"
`;
    throw new Error(_msg + (msg || ""));
  }
  if (JSON.stringify(a) === JSON.stringify(b)) {
    return;
  } else if (a === b) {
    return;
  }
  throwNow();
}

Deno.test("test normalizeHashToSRI", () => {
  type TestCase = {
    input: Hash;
    expectedOutput: HashString;
  };

  const testCases: Array<TestCase> = [{
    input: {
      string:
        "b9a4cf361a7c9740ecb75e00b5e2c006bd4e5d40e442d26c5f2760286fa66796",
      algorithm: "sha256",
      encoding: "hex",
    },
    expectedOutput: "sha256-uaTPNhp8l0Dst14AteLABr1OXUDkQtJsXydgKG+mZ5Y=",
  }, {
    input: {
      string:
        "c698fc32f00cd267c1684b1d413d784260d7e7798f2bf506803e418497d839b5",
      algorithm: "sha256",
      encoding: "hex",
    },
    expectedOutput: "sha256-xpj8MvAM0mfBaEsdQT14QmDX53mPK/UGgD5BhJfYObU=",
  }, {
    input: {
      string:
        "03ae55d5635e6a4ca894a003d9297cd9cd283af2e7d761dd3de13663849a9423",
      algorithm: "sha256",
      encoding: "hex",
    },
    expectedOutput: "sha256-A65V1WNeakyolKAD2Sl82c0oOvLn12HdPeE2Y4SalCM=",
  }, {
    input: {
      string:
        "b5f9471f1830595e63a2b7d62821ac822a19e16899e6584799be63f17a1fbc30",
      algorithm: "sha256",
      encoding: "hex",
    },
    expectedOutput: "sha256-tflHHxgwWV5jorfWKCGsgioZ4WiZ5lhHmb5j8XofvDA=",
  }, {
    input: {
      string:
        "sha256-0bdd66a72445f07b92cd95089cfc45d22345afc92ec0ff42554f31d5e533114d",
      algorithm: "sha256",
      encoding: "hex",
    },
    expectedOutput: "sha256-C91mpyRF8HuSzZUInPxF0iNFr8kuwP9CVU8x1eUzEU0=",
  }, {
    input: {
      string:
        "e15b9abe629e17be90cc6216327f03a29eae613365f1353837fa749aad29ce7b",
      algorithm: "sha256",
      encoding: "hex",
    },
    expectedOutput: "sha256-4VuavmKeF76QzGIWMn8Dop6uYTNl8TU4N/p0mq0pzns=",
  }, {
    input: {
      string:
        "sha512-jif86Xt4RqeqhpjbyEDFPjZQVFzvYg7vfu0MFqON+qwaYXeQhbiXO3Nps5LHzuuAbC7ET/eTwM8wdztDmzby7A==",
      algorithm: "sha512",
      encoding: "base64",
    },
    expectedOutput:
      "sha512-jif86Xt4RqeqhpjbyEDFPjZQVFzvYg7vfu0MFqON+qwaYXeQhbiXO3Nps5LHzuuAbC7ET/eTwM8wdztDmzby7A==",
  }, {
    input: {
      string:
        "sha512-MIwQGEfVMrbcMetftWD8Jz75xk3nMUPbaDjlDKvs6FQDKEnfTTsgKliMjEt86qlSlXEb6Ba2mk8vPcbGTZOasw==",
      algorithm: "sha512",
      encoding: "base64",
    },
    expectedOutput:
      "sha512-MIwQGEfVMrbcMetftWD8Jz75xk3nMUPbaDjlDKvs6FQDKEnfTTsgKliMjEt86qlSlXEb6Ba2mk8vPcbGTZOasw==",
  }, {
    input: {
      string:
        "sha512-R5muMcZob3/Jjchn5LcO8jdKwSCbzqmPB6ruBxMcf9kbxtniZHP327s6C37iOfuw8mbKK3cAQa7sEl7afLrQ8A==",
      algorithm: "sha512",
      encoding: "base64",
    },
    expectedOutput:
      "sha512-R5muMcZob3/Jjchn5LcO8jdKwSCbzqmPB6ruBxMcf9kbxtniZHP327s6C37iOfuw8mbKK3cAQa7sEl7afLrQ8A==",
  }];

  testCases.forEach((testCase) => {
    assertEq(
      testCase.expectedOutput,
      normalizeHashToSRI(
        testCase.input,
      ),
    );
  });
});
