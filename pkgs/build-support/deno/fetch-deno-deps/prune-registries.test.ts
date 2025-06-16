import { assertEquals } from "@std/assert";
import type {
  LockJson,
  MetaJson,
  PackageInfo,
  PackagesByRegistry,
  PackageSpecifiers,
  RegistryJson,
} from "./prune-registries.ts";
import {
  getAllPackageRegistries,
  getAllPackagesByPackageRegistry,
  getScopedName,
  parsePackageSpecifier,
  pruneMetaJson,
  pruneRegistryJson,
} from "./prune-registries.ts";

type Fixture<T, R> = {
  testValue: T;
  expectedValue: R;
};

type Fixtures<T, R> = Array<Fixture<T, R>>;

function testFactory<T, R>(
  assertFunction: (actual: R, expected: R, msg?: string) => void,
  testFunction: (args: T) => R,
  fixtures: Fixtures<T, R>
): () => void {
  return () => {
    fixtures.forEach((fixture) => {
      assertFunction(testFunction(fixture.testValue), fixture.expectedValue);
    });
  };
}

Deno.test("parsePackageSpecifier", () => {
  type Args = string;
  type ReturnValue = PackageInfo;
  const fixtures: Array<Fixture<Args, ReturnValue>> = [
    {
      testValue: "jsr:@std/assert@1.0.13",
      expectedValue: {
        full: "jsr:@std/assert@1.0.13",
        registry: "jsr",
        scope: "@std",
        name: "assert",
        version: "1.0.13",
        suffix: undefined,
      },
    },
    {
      testValue: "npm:ini@5.0.0",
      expectedValue: {
        full: "npm:ini@5.0.0",
        registry: "npm",
        scope: undefined,
        name: "ini",
        version: "5.0.0",
        suffix: undefined,
      },
    },
    {
      testValue: "npm:@amazn/style-dictionary@4.2.4_prettier@3.5.3",
      expectedValue: {
        full: "npm:@amazn/style-dictionary@4.2.4_prettier@3.5.3",
        registry: "npm",
        scope: "@amazn",
        name: "style-dictionary",
        version: "4.2.4",
        suffix: "_prettier@3.5.3",
      },
    },
  ];
  testFactory(assertEquals, parsePackageSpecifier, fixtures)();
});

Deno.test("getScopedName", () => {
  type Args = { name: string; scope?: string };
  type ReturnValue = string;
  const fixtures: Array<Fixture<Args, ReturnValue>> = [
    {
      testValue: { name: "assert", scope: undefined },
      expectedValue: "assert",
    },
    {
      testValue: { name: "assert", scope: "std" },
      expectedValue: "@std/assert",
    },
    {
      testValue: { name: "assert", scope: "@std" },
      expectedValue: "@std/assert",
    },
  ];
  testFactory(
    assertEquals,
    (args: Args) => getScopedName(args.name, args.scope),
    fixtures
  )();
});

Deno.test("getAllPackageRegistries", () => {
  type Args = PackageSpecifiers;
  type ReturnValue = Set<string>;
  const fixtures: Array<Fixture<Args, ReturnValue>> = [
    {
      testValue: {
        "jsr:@std/assert@1.0.13": "1.0.13",
        "jsr:@std/cli@1.0.16": "1.0.16",
        "jsr:@std/fs@1.0.16": "1.0.16",
        "jsr:@std/internal@^1.0.6": "1.0.7",
        "jsr:@std/path@1.0.9": "1.0.9",
        "jsr:@std/path@^1.0.8": "1.0.9",
        "npm:ini@5.0.0": "5.0.0",
      },
      expectedValue: new Set(["jsr", "npm"]),
    },
  ];
  testFactory(assertEquals, getAllPackageRegistries, fixtures)();
});

Deno.test("getAllPackagesByPackageRegistry", () => {
  type Args = { lockJson: LockJson; registries: Set<string> };
  type ReturnValue = PackagesByRegistry;
  const fixtures: Array<Fixture<Args, ReturnValue>> = [
    {
      testValue: {
        lockJson: JSON.parse(`
{
  "version": "4",
  "specifiers": {
    "jsr:@std/assert@1.0.13": "1.0.13",
    "jsr:@std/cli@1.0.16": "1.0.16",
    "jsr:@std/fs@1.0.16": "1.0.16",
    "jsr:@std/internal@^1.0.6": "1.0.7",
    "jsr:@std/path@1.0.9": "1.0.9",
    "jsr:@std/path@^1.0.8": "1.0.9",
    "npm:ini@5.0.0": "5.0.0"
  },
  "jsr": {
    "@std/assert@1.0.13": {
      "integrity": "ae0d31e41919b12c656c742b22522c32fb26ed0cba32975cb0de2a273cb68b29",
      "dependencies": [
        "jsr:@std/internal"
      ]
    },
    "@std/cli@1.0.16": {
      "integrity": "02df293099c35b9e97d8ca05f57f54bd1ee08134f25d19a4756b3924695f4b00"
    },
    "@std/fs@1.0.16": {
      "integrity": "81878f62b6eeda0bf546197fc3daa5327c132fee1273f6113f940784a468b036",
      "dependencies": [
        "jsr:@std/path@^1.0.8"
      ]
    },
    "@std/internal@1.0.7": {
      "integrity": "39eeb5265190a7bc5d5591c9ff019490bd1f2c3907c044a11b0d545796158a0f"
    },
    "@std/path@1.0.9": {
      "integrity": "260a49f11edd3db93dd38350bf9cd1b4d1366afa98e81b86167b4e3dd750129e"
    }
  },
  "npm": {
    "ini@5.0.0": {
      "integrity": "sha512-+N0ngpO3e7cRUWOJAS7qw0IZIVc6XPrW4MlFBdD066F2L4k1L6ker3hLqSq7iXxU5tgS4WGkIUElWn5vogAEnw=="
    }
  },
  "workspace": {
    "dependencies": [
      "jsr:@std/assert@1.0.13",
      "jsr:@std/cli@1.0.16",
      "jsr:@std/fs@1.0.16",
      "jsr:@std/path@1.0.9",
      "npm:ini@5.0.0"
    ]
  }
}
`),
        registries: new Set(["npm", "jsr"]),
      },
      expectedValue: {
        jsr: {
          "@std/assert": {
            "1.0.13": {
              full: "@std/assert@1.0.13",
              registry: undefined,
              scope: "@std",
              name: "assert",
              version: "1.0.13",
              suffix: undefined,
            },
          },
          "@std/cli": {
            "1.0.16": {
              full: "@std/cli@1.0.16",
              registry: undefined,
              scope: "@std",
              name: "cli",
              version: "1.0.16",
              suffix: undefined,
            },
          },
          "@std/fs": {
            "1.0.16": {
              full: "@std/fs@1.0.16",
              registry: undefined,
              scope: "@std",
              name: "fs",
              version: "1.0.16",
              suffix: undefined,
            },
          },
          "@std/internal": {
            "1.0.7": {
              full: "@std/internal@1.0.7",
              registry: undefined,
              scope: "@std",
              name: "internal",
              version: "1.0.7",
              suffix: undefined,
            },
          },
          "@std/path": {
            "1.0.9": {
              full: "@std/path@1.0.9",
              registry: undefined,
              scope: "@std",
              name: "path",
              version: "1.0.9",
              suffix: undefined,
            },
          },
        },
        npm: {
          ini: {
            "5.0.0": {
              full: "ini@5.0.0",
              registry: undefined,
              scope: undefined,
              name: "ini",
              version: "5.0.0",
              suffix: undefined,
            },
          },
        },
      },
    },
  ];
  testFactory(
    assertEquals,
    (args: Args) =>
      getAllPackagesByPackageRegistry(args.lockJson, args.registries),
    fixtures
  )();
});

Deno.test("pruneMetaJson", () => {
  type Args = {
    metaJson: MetaJson;
    jsrPackages: PackagesByRegistry;
    registry: string;
  };
  type ReturnValue = MetaJson;
  const fixtures: Array<Fixture<Args, ReturnValue>> = [
    {
      testValue: {
        metaJson: {
          scope: "std",
          name: "cli",
          latest: "1.0.17",
          versions: {
            "0.222.0": {},
            "1.0.16": {},
            "0.218.2": {},
            "0.218.0": {},
            "1.0.10": {},
            "0.224.6": {},
            "1.0.4": {},
            "1.0.8": {},
            "1.0.2": {},
            "0.211.0": {},
            "0.213.0": {},
            "1.0.0-rc.2": {},
            "1.0.3": {},
            "1.0.0-rc.5": {},
            "0.210.0": {},
            "0.209.0": {},
            "0.212.0": {},
            "0.208.0": {},
            "1.0.7": {},
            "1.0.0": {},
            "0.220.1": {},
            "0.224.2": {},
            "1.0.17": {},
            "1.0.1": {},
            "0.221.0": {},
            "0.224.5": {},
            "0.216.0": {},
            "0.207.0": {},
            "0.224.4": {},
            "1.0.0-rc.4": {},
            "0.214.0": {},
            "0.223.0": {},
            "1.0.6": {},
            "0.224.1": {},
            "0.224.0": {},
            "1.0.15": {},
            "1.0.0-rc.3": {},
            "0.224.3": {},
            "1.0.14": {},
            "1.0.9": {},
            "0.222.1": {},
            "1.0.13": {},
            "1.0.0-rc.1": {},
            "0.219.0": {},
            "1.0.5": {},
            "1.0.11": {},
            "0.224.7": {},
            "0.215.0": {},
            "1.0.12": {},
            "0.217.0": {},
            "0.213.1": {},
            "0.219.1": {},
            "0.218.1": {},
          },
        },
        jsrPackages: {
          jsr: {
            "@luca/cases": {
              "1.0.0": {
                full: "@luca/cases@1.0.0",
                registry: undefined,
                scope: "@luca",
                name: "cases",
                version: "1.0.0",
                suffix: undefined,
              },
            },
            "@std/cli": {
              "1.0.17": {
                full: "@std/cli@1.0.17",
                registry: undefined,
                scope: "@std",
                name: "cli",
                version: "1.0.17",
                suffix: undefined,
              },
            },
          },
        },
        registry: "jsr",
      },
      expectedValue: {
        scope: "std",
        name: "cli",
        latest: "",
        versions: { "1.0.17": {} },
      },
    },
    {
      testValue: {
        metaJson: {
          scope: "luca",
          name: "cases",
          latest: "1.0.0",
          versions: { "1.0.0": {} },
        },
        jsrPackages: {
          jsr: {
            "@luca/cases": {
              "1.0.0": {
                full: "@luca/cases@1.0.0",
                registry: undefined,
                scope: "@luca",
                name: "cases",
                version: "1.0.0",
                suffix: undefined,
              },
            },
            "@std/cli": {
              "1.0.17": {
                full: "@std/cli@1.0.17",
                registry: undefined,
                scope: "@std",
                name: "cli",
                version: "1.0.17",
                suffix: undefined,
              },
            },
          },
        },
        registry: "jsr",
      },
      expectedValue: {
        scope: "luca",
        name: "cases",
        latest: "",
        versions: { "1.0.0": {} },
      },
    },
  ];
  testFactory(
    assertEquals,
    (args: Args) =>
      pruneMetaJson(args.metaJson, args.jsrPackages, args.registry),
    fixtures
  )();
});

Deno.test("pruneRegistryJson", () => {
  type Args = {
    registryJson: RegistryJson;
    nonJsrPackages: PackagesByRegistry;
    registry: string;
  };
  type ReturnValue = RegistryJson;
  const fixtures: Array<Fixture<Args, ReturnValue>> = [
    {
      testValue: {
        registryJson: {
          name: "decamelize",
          versions: {
            "1.1.0": {
              version: "1.1.0",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-1.1.0.tgz",
                shasum: "fe90c002a0acec1435120ce83a6945641018d0c8",
                integrity:
                  "sha512-n7ZK2Y9+g6neJhxuH+BejddHBOZXp9vh5KcKbedUHVjl1SCU3nnO8iWTqNxLi7OCYabTpypddtlylvtecwrW1w==",
              },
              bin: null,
              dependencies: {},
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "node test.js" },
              deprecated: null,
            },
            "3.1.1": {
              version: "3.1.1",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-3.1.1.tgz",
                shasum: "ebf473c6f8607bd70fd9ed6d892da27c5eb8539e",
                integrity:
                  "sha512-pSJTQCBDZxv8siK5p/M42ZdhThhTtx3JU/OKli0yQSKebfM9q92op6zF7krYrWVKRtsE/RwTDiZLliMV3ECkXQ==",
              },
              bin: null,
              dependencies: { xregexp: "^4.2.4" },
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "xo && ava && tsd" },
              deprecated: null,
            },
            "3.1.0": {
              version: "3.1.0",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-3.1.0.tgz",
                shasum: "81cd3f2e9911b8874e290d249da2c366453641d4",
                integrity:
                  "sha512-fgHaR077tSDdzV2ExQwtJ8Kx8LYOvnf1cm5JaQ1ESeGgO8CTH7wv3202zJEg1YND0Fx7WQDxeuDPdAPMERXBEg==",
              },
              bin: null,
              dependencies: { xregexp: "^4.2.4" },
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "xo && ava && tsd" },
              deprecated: null,
            },
            "1.1.1": {
              version: "1.1.1",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-1.1.1.tgz",
                shasum: "8871479a6c0487f5653d48a992f1d0381ca6f031",
                integrity:
                  "sha512-l2nWbx7Uy2MCRQjEJQm6lep1GwWzl1DHr9wTcQzLQYOSes2RwALmR87OG91eNjoMbih7xrYhZX9cPWP3U7Kxmw==",
              },
              bin: null,
              dependencies: {},
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "node test.js" },
              deprecated: null,
            },
            "1.2.0": {
              version: "1.2.0",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz",
                shasum: "f6534d15148269b20352e7bee26f501f9a191290",
                integrity:
                  "sha512-z2S+W9X73hAUUki+N+9Za2lBlun89zigOyGrsax+KUQ6wKW4ZoWpEYBkGhQjwAjjDCkWxhY0VKEhk8wzY7F5cA==",
              },
              bin: null,
              dependencies: {},
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "xo && ava" },
              deprecated: null,
            },
            "2.0.0": {
              version: "2.0.0",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-2.0.0.tgz",
                shasum: "656d7bbc8094c4c788ea53c5840908c9c7d063c7",
                integrity:
                  "sha512-Ikpp5scV3MSYxY39ymh45ZLEecsTdv/Xj2CaQfI8RLMuwi7XvjX9H/fhraiSuU+C5w5NTDu4ZU72xNiZnurBPg==",
              },
              bin: null,
              dependencies: { xregexp: "4.0.0" },
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "xo && ava" },
              deprecated: null,
            },
            "3.0.0": {
              version: "3.0.0",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-3.0.0.tgz",
                shasum: "5efdacb0ff1b6e4031ccd0da71257340c1b846b7",
                integrity:
                  "sha512-NUW7GyGP5Al0a4QIr3qj/FVzPNjpixU/HWPMJ7kuFlMpVnLcNeUrKsvOOMlywL2QPr/JG3am40S5a2G9F0REcw==",
              },
              bin: null,
              dependencies: { xregexp: "^4.2.4" },
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "xo && ava && tsd-check" },
              deprecated: null,
            },
            "5.0.0": {
              version: "5.0.0",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-5.0.0.tgz",
                shasum: "88358157b010ef133febfd27c18994bd80c6215b",
                integrity:
                  "sha512-U75DcT5hrio3KNtvdULAWnLiAPbFUC4191ldxMmj4FA/mRuBnmDwU0boNfPyFRhnan+Jm+haLeSn3P0afcBn4w==",
              },
              bin: null,
              dependencies: {},
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "xo && ava && tsd" },
              deprecated: null,
            },
            "1.1.2": {
              version: "1.1.2",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-1.1.2.tgz",
                shasum: "dcc93727be209632e98b02718ef4cb79602322f2",
                integrity:
                  "sha512-TzUj+sMdUozL/R01HUZfQNgHBclsYvlLLDoXpoVT//50AAuGNYj1jayRptx0gBgBWaViSim8YHnx0NgLmdx2KQ==",
              },
              bin: null,
              dependencies: { "escape-string-regexp": "^1.0.4" },
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "xo && ava" },
              deprecated: null,
            },
            "4.0.0": {
              version: "4.0.0",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-4.0.0.tgz",
                shasum: "aa472d7bf660eb15f3494efd531cab7f2a709837",
                integrity:
                  "sha512-9iE1PgSik9HeIIw2JO94IidnE3eBoQrFJ3w7sFuzSX4DpmZ3v5sZpUiV5Swcf6mQEF+Y0ru8Neo+p+nyh2J+hQ==",
              },
              bin: null,
              dependencies: {},
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "xo && ava && tsd" },
              deprecated: null,
            },
            "5.0.1": {
              version: "5.0.1",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-5.0.1.tgz",
                shasum: "db11a92e58c741ef339fb0a2868d8a06a9a7b1e9",
                integrity:
                  "sha512-VfxadyCECXgQlkoEAjeghAr5gY3Hf+IKjKb+X8tGVDtveCjN+USwprd2q3QXBR9T1+x2DG0XZF5/w+7HAtSaXA==",
              },
              bin: null,
              dependencies: {},
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "xo && ava && tsd" },
              deprecated: null,
            },
            "1.0.0": {
              version: "1.0.0",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-1.0.0.tgz",
                shasum: "5287122f71691d4505b18ff2258dc400a5b23847",
                integrity:
                  "sha512-6OlbjTSfBWyqM8oFO7TYc6DgCIiT6vgCiZ973GDA98xVf+DOXVZvYLzRyi0HEJy5J31/69lel4AeY78OaasBLQ==",
              },
              bin: null,
              dependencies: {},
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "node test.js" },
              deprecated: null,
            },
            "3.2.0": {
              version: "3.2.0",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-3.2.0.tgz",
                shasum: "84b8e8f4f8c579f938e35e2cc7024907e0090851",
                integrity:
                  "sha512-4TgkVUsmmu7oCSyGBm5FvfMoACuoh9EOidm7V5/J2X2djAwwt57qb3F2KMP2ITqODTCSwb+YRV+0Zqrv18k/hw==",
              },
              bin: null,
              dependencies: { xregexp: "^4.2.4" },
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "xo && ava && tsd" },
              deprecated: null,
            },
            "6.0.0": {
              version: "6.0.0",
              dist: {
                tarball:
                  "https://registry.npmjs.org/decamelize/-/decamelize-6.0.0.tgz",
                shasum: "8cad4d916fde5c41a264a43d0ecc56fe3d31749e",
                integrity:
                  "sha512-Fv96DCsdOgB6mdGl67MT5JaTNKRzrzill5OH5s8bjYJXVlcXyPYGyPsUkWyGV5p1TXI5esYIYMMeDJL0hEIwaA==",
              },
              bin: null,
              dependencies: {},
              optionalDependencies: {},
              peerDependencies: {},
              peerDependenciesMeta: {},
              os: [],
              cpu: [],
              scripts: { test: "xo && ava && tsd" },
              deprecated: null,
            },
          },
          "dist-tags": { latest: "6.0.0" },
        },
        nonJsrPackages: {
          npm: {
            "ansi-regex": {
              "3.0.1": {
                full: "ansi-regex@3.0.1",
                registry: undefined,
                scope: undefined,
                name: "ansi-regex",
                version: "3.0.1",
                suffix: undefined,
              },
              "5.0.1": {
                full: "ansi-regex@5.0.1",
                registry: undefined,
                scope: undefined,
                name: "ansi-regex",
                version: "5.0.1",
                suffix: undefined,
              },
            },
            "ansi-styles": {
              "4.3.0": {
                full: "ansi-styles@4.3.0",
                registry: undefined,
                scope: undefined,
                name: "ansi-styles",
                version: "4.3.0",
                suffix: undefined,
              },
            },
            camelcase: {
              "5.3.1": {
                full: "camelcase@5.3.1",
                registry: undefined,
                scope: undefined,
                name: "camelcase",
                version: "5.3.1",
                suffix: undefined,
              },
            },
            cliui: {
              "6.0.0": {
                full: "cliui@6.0.0",
                registry: undefined,
                scope: undefined,
                name: "cliui",
                version: "6.0.0",
                suffix: undefined,
              },
            },
            "color-convert": {
              "2.0.1": {
                full: "color-convert@2.0.1",
                registry: undefined,
                scope: undefined,
                name: "color-convert",
                version: "2.0.1",
                suffix: undefined,
              },
            },
            "color-name": {
              "1.1.4": {
                full: "color-name@1.1.4",
                registry: undefined,
                scope: undefined,
                name: "color-name",
                version: "1.1.4",
                suffix: undefined,
              },
            },
            cowsay: {
              "1.6.0": {
                full: "cowsay@1.6.0",
                registry: undefined,
                scope: undefined,
                name: "cowsay",
                version: "1.6.0",
                suffix: undefined,
              },
            },
            decamelize: {
              "1.2.0": {
                full: "decamelize@1.2.0",
                registry: undefined,
                scope: undefined,
                name: "decamelize",
                version: "1.2.0",
                suffix: undefined,
              },
            },
            "emoji-regex": {
              "8.0.0": {
                full: "emoji-regex@8.0.0",
                registry: undefined,
                scope: undefined,
                name: "emoji-regex",
                version: "8.0.0",
                suffix: undefined,
              },
            },
            "find-up": {
              "4.1.0": {
                full: "find-up@4.1.0",
                registry: undefined,
                scope: undefined,
                name: "find-up",
                version: "4.1.0",
                suffix: undefined,
              },
            },
            "get-caller-file": {
              "2.0.5": {
                full: "get-caller-file@2.0.5",
                registry: undefined,
                scope: undefined,
                name: "get-caller-file",
                version: "2.0.5",
                suffix: undefined,
              },
            },
            "get-stdin": {
              "8.0.0": {
                full: "get-stdin@8.0.0",
                registry: undefined,
                scope: undefined,
                name: "get-stdin",
                version: "8.0.0",
                suffix: undefined,
              },
            },
            "is-fullwidth-code-point": {
              "2.0.0": {
                full: "is-fullwidth-code-point@2.0.0",
                registry: undefined,
                scope: undefined,
                name: "is-fullwidth-code-point",
                version: "2.0.0",
                suffix: undefined,
              },
              "3.0.0": {
                full: "is-fullwidth-code-point@3.0.0",
                registry: undefined,
                scope: undefined,
                name: "is-fullwidth-code-point",
                version: "3.0.0",
                suffix: undefined,
              },
            },
            "locate-path": {
              "5.0.0": {
                full: "locate-path@5.0.0",
                registry: undefined,
                scope: undefined,
                name: "locate-path",
                version: "5.0.0",
                suffix: undefined,
              },
            },
            "p-limit": {
              "2.3.0": {
                full: "p-limit@2.3.0",
                registry: undefined,
                scope: undefined,
                name: "p-limit",
                version: "2.3.0",
                suffix: undefined,
              },
            },
            "p-locate": {
              "4.1.0": {
                full: "p-locate@4.1.0",
                registry: undefined,
                scope: undefined,
                name: "p-locate",
                version: "4.1.0",
                suffix: undefined,
              },
            },
            "p-try": {
              "2.2.0": {
                full: "p-try@2.2.0",
                registry: undefined,
                scope: undefined,
                name: "p-try",
                version: "2.2.0",
                suffix: undefined,
              },
            },
            "path-exists": {
              "4.0.0": {
                full: "path-exists@4.0.0",
                registry: undefined,
                scope: undefined,
                name: "path-exists",
                version: "4.0.0",
                suffix: undefined,
              },
            },
            "require-directory": {
              "2.1.1": {
                full: "require-directory@2.1.1",
                registry: undefined,
                scope: undefined,
                name: "require-directory",
                version: "2.1.1",
                suffix: undefined,
              },
            },
            "require-main-filename": {
              "2.0.0": {
                full: "require-main-filename@2.0.0",
                registry: undefined,
                scope: undefined,
                name: "require-main-filename",
                version: "2.0.0",
                suffix: undefined,
              },
            },
            "set-blocking": {
              "2.0.0": {
                full: "set-blocking@2.0.0",
                registry: undefined,
                scope: undefined,
                name: "set-blocking",
                version: "2.0.0",
                suffix: undefined,
              },
            },
            "string-width": {
              "2.1.1": {
                full: "string-width@2.1.1",
                registry: undefined,
                scope: undefined,
                name: "string-width",
                version: "2.1.1",
                suffix: undefined,
              },
              "4.2.3": {
                full: "string-width@4.2.3",
                registry: undefined,
                scope: undefined,
                name: "string-width",
                version: "4.2.3",
                suffix: undefined,
              },
            },
            "strip-ansi": {
              "4.0.0": {
                full: "strip-ansi@4.0.0",
                registry: undefined,
                scope: undefined,
                name: "strip-ansi",
                version: "4.0.0",
                suffix: undefined,
              },
              "6.0.1": {
                full: "strip-ansi@6.0.1",
                registry: undefined,
                scope: undefined,
                name: "strip-ansi",
                version: "6.0.1",
                suffix: undefined,
              },
            },
            "strip-final-newline": {
              "2.0.0": {
                full: "strip-final-newline@2.0.0",
                registry: undefined,
                scope: undefined,
                name: "strip-final-newline",
                version: "2.0.0",
                suffix: undefined,
              },
            },
            "which-module": {
              "2.0.1": {
                full: "which-module@2.0.1",
                registry: undefined,
                scope: undefined,
                name: "which-module",
                version: "2.0.1",
                suffix: undefined,
              },
            },
            "wrap-ansi": {
              "6.2.0": {
                full: "wrap-ansi@6.2.0",
                registry: undefined,
                scope: undefined,
                name: "wrap-ansi",
                version: "6.2.0",
                suffix: undefined,
              },
            },
            y18n: {
              "4.0.3": {
                full: "y18n@4.0.3",
                registry: undefined,
                scope: undefined,
                name: "y18n",
                version: "4.0.3",
                suffix: undefined,
              },
            },
            "yargs-parser": {
              "18.1.3": {
                full: "yargs-parser@18.1.3",
                registry: undefined,
                scope: undefined,
                name: "yargs-parser",
                version: "18.1.3",
                suffix: undefined,
              },
            },
            yargs: {
              "15.4.1": {
                full: "yargs@15.4.1",
                registry: undefined,
                scope: undefined,
                name: "yargs",
                version: "15.4.1",
                suffix: undefined,
              },
            },
          },
        },
        registry: "npm",
      },
      expectedValue: {
        name: "decamelize",
        versions: {
          "1.2.0": {
            version: "1.2.0",
            dist: {
              tarball:
                "https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz",
              shasum: "f6534d15148269b20352e7bee26f501f9a191290",
              integrity:
                "sha512-z2S+W9X73hAUUki+N+9Za2lBlun89zigOyGrsax+KUQ6wKW4ZoWpEYBkGhQjwAjjDCkWxhY0VKEhk8wzY7F5cA==",
            },
            bin: null,
            dependencies: {},
            optionalDependencies: {},
            peerDependencies: {},
            peerDependenciesMeta: {},
            os: [],
            cpu: [],
            scripts: { test: "xo && ava" },
            deprecated: null,
          },
        },
        "dist-tags": {},
      },
    },
  ];
  testFactory(
    assertEquals,
    (args: Args) =>
      pruneRegistryJson(args.registryJson, args.nonJsrPackages, args.registry),
    fixtures
  )();
});
