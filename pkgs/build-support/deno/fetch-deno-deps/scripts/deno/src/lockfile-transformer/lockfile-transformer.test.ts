import { parsePackageSpecifier } from "./lockfile-transformer.ts";
import type { PackageSpecifier } from "../types.d.ts";
import { assertEq } from "../utils.ts";

Deno.test("test parsePackageSpecifier", () => {
  type TestCase = {
    input: string;
    expectedOutput: PackageSpecifier;
  };

  const testCases: Array<TestCase> = [{
    input: "@babel/helper-module-transforms@7.28.3_@babel+core@7.28.4",
    expectedOutput: {
      "fullString": "@babel/helper-module-transforms@7.28.3_@babel+core@7.28.4",
      "registry": null,
      "scope": "babel",
      "name": "helper-module-transforms",
      "version": "7.28.3",
      "suffix": "_@babel+core@7.28.4",
    },
  }, {
    input:
      "npm:@prefresh/vite@2.4.10_preact@10.27.2_vite@7.1.5__@types+node@24.3.3__picomatch@4.0.3_@types+node@24.3.3",
    expectedOutput: {
      "fullString":
        "npm:@prefresh/vite@2.4.10_preact@10.27.2_vite@7.1.5__@types+node@24.3.3__picomatch@4.0.3_@types+node@24.3.3",
      "registry": "npm",
      "scope": "prefresh",
      "name": "vite",
      "version": "2.4.10",
      "suffix":
        "_preact@10.27.2_vite@7.1.5__@types+node@24.3.3__picomatch@4.0.3_@types+node@24.3.3",
    },
  }, {
    input: "string_decoder@1.3.0",
    expectedOutput: {
      "fullString": "string_decoder@1.3.0",
      "registry": null,
      "scope": null,
      "name": "string_decoder",
      "version": "1.3.0",
      "suffix": null,
    },
  }, {
    input: "registry@_-/:@scope:@_-/name:-_/@version:@-/_suffix:@-_/",
    expectedOutput: {
      "fullString": "registry@_-/:@scope:@_-/name:-_/@version:@-/_suffix:@-_/",
      "registry": "registry@_-/",
      "scope": "scope:@_-",
      "name": "name:-_/",
      "version": "version:@-/",
      "suffix": "_suffix:@-_/",
    },
  }];

  testCases.forEach((testCase) => {
    assertEq(testCase.expectedOutput, parsePackageSpecifier(testCase.input));
  });
});
