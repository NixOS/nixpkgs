{
  lib,
  testers,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

let
  testGoModules = testers.invalidateFetcherByDrvHash (args: (buildGoModule args).goModules);
in

lib.recurseIntoAttrs {
  # sets modRoot
  modRoot = testGoModules {
    pname = "chroma";
    version = "2.27.0";
    src = fetchFromGitHub {
      owner = "alecthomas";
      repo = "chroma";
      tag = "v2.27.0";
      hash = "sha256-iIu0FFAavXbma/LiKEDltvrGMYYd4uxSfHpNTrmN6aI=";
    };
    modRoot = "./cmd/chroma";
    vendorHash = "sha256-B2TvCIBqgdTpQApmQkO2COIarqmgF9mhZ0HG5aFgVhY=";
  };

  # proxyVendor = true;
  proxyVendor = testGoModules {
    pname = "obs-cli";
    version = "0.5.0";
    src = fetchFromGitHub {
      owner = "muesli";
      repo = "obs-cli";
      tag = "v0.5.0";
      hash = "sha256-4tjS+PWyP/T0zs4IGE6VQ5c+3tuqxlBwfpPBVEcim6c=";
    };
    proxyVendor = true;
    vendorHash = "sha256-tjQOHvmhHyVMqIJQvFaisEqci1wkB4ke/a+GSgwXzCo=";
  };

  # proxyVendor = true; with modRoot
  proxyVendor-modRoot = testGoModules {
    pname = "gorm-gentool";
    version = "0.0.2";
    src = fetchFromGitHub {
      owner = "go-gorm";
      repo = "gen";
      tag = "tools/gentool/v0.0.2";
      hash = "sha256-8xuprFktGflx/5BR3Sbzx/MWerSp57q2Ky2Yn5P6Y28=";
    };
    modRoot = "tools/gentool";
    proxyVendor = true;
    vendorHash = "sha256-0VU+zGQb6Ob9V2zOsUO5+ObUFdQO26236Ei2/TqjTBs=";
  };

  # deleteVendor = true;
  deleteVendor = testGoModules {
    pname = "2fa";
    version = "1.2.0";
    src = fetchFromGitHub {
      owner = "rsc";
      repo = "2fa";
      tag = "v1.2.0";
      hash = "sha256-cB5iADZwvJQwwK1GockE2uicFlqFMEAY6xyeXF5lnUY=";
    };
    deleteVendor = true;
    vendorHash = "sha256-4h/+ZNxlJPYY0Kyu2vDE1pDXxC/kGE5JdnagWVOGzAE=";
  };

  # patches adding go.mod/go.sum, with deleteVendor = true;
  patches = testGoModules {
    pname = "gdrive";
    version = "2.1.1";
    src = fetchFromGitHub {
      owner = "prasmussen";
      repo = "gdrive";
      tag = "2.1.1";
      hash = "sha256-2dJmGFHfGSroucn4WgiV2NExBs5wtMDe2kX1jDBwbRs=";
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/prasmussen/gdrive/pull/585/commits/faa6fc3dc104236900caa75eb22e9ed2e5ecad42.patch";
        hash = "sha256-W8o2ZfhQFJISHfPavjx9sw5UB6xOZ7qRW4L0bHNddS8=";
      })
    ];
    deleteVendor = true;
    vendorHash = "sha256-sHNP1YwnZYu0UfgLx5+gxJmesY8Brt7rr9cptlyk9Bk=";
  };

  # sets env
  env = testGoModules {
    pname = "snitch";
    version = "0.2.2";
    src = fetchFromGitHub {
      owner = "karol-broda";
      repo = "snitch";
      tag = "v0.2.2";
      hash = "sha256-SssAiRUfUaDgAoVO2rDacru8e914Wl+4sA4JQ4Mv4eA=";
    };
    env.CGO_ENABLED = 0;
    vendorHash = "sha256-fX3wOqeOgjH7AuWGxPQxJ+wbhp240CW8tiF4rVUUDzk=";
  };

  # sets modPostBuild
  modPostBuild = testGoModules {
    pname = "json-patch";
    version = "5.9.11";
    src = fetchFromGitHub {
      owner = "evanphx";
      repo = "json-patch";
      tag = "v5.9.11";
      hash = "sha256-lRgz3Bw2mwQSfXvXmKUcWfexEf3YHBFy47tqWB6lzWs=";
    };
    modRoot = "v5";
    modPostBuild = ''
      test -f vendor/modules.txt
    '';
    vendorHash = "sha256-W6XVd68MS0ungMgam8jefYMVhyiN6/DB+bliFzs2rdk=";
  };

  # overrideModAttrs, dropping a preBuild that must not run in goModules
  overrideModAttrs = testGoModules {
    pname = "yubihsm-connector";
    version = "3.0.7";
    src = fetchFromGitHub {
      owner = "Yubico";
      repo = "yubihsm-connector";
      tag = "3.0.7";
      hash = "sha256-ddf8IamX8wC8IG9puFDoSKsVqc9KE/LtsJ0Wk0FFquw=";
    };
    preBuild = ''
      GOOS= GOARCH= go generate
    '';
    overrideModAttrs = _: {
      preBuild = null;
    };
    vendorHash = "sha256-vtIXFOptDbBKjnDUSD9ng5tnfYQ3lklwgcEUvKMdCOM=";
  };
}
