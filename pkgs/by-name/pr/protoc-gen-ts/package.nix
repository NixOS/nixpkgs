{ lib, buildNpmPackage, fetchurl }:

buildNpmPackage rec {
  pname = "protoc-gen-ts";
  version = "2.9.1";

  packageName = "@protobuf-ts/protoc";
  src = fetchurl {
    url =
      "https://registry.npmjs.org/@protobuf-ts/protoc/-/protoc-${version}.tgz";
    # this isnt the correct hash
    sha512 =
      "/q2iVDwVDijfZlFZnnm3W6ALbybNskNSww88TfYBaJH49PuQMqhcXUPRu28UouJr9sc/Lr5k6t0TB9Nff3UIsA==";
  };
  # this isnt the correct hash
  npmDepsHash = "sha256-diGu53lJi+Fs7pTAQGCXoDtP7YyKZLIN/2Wo+e1Mzc4=";

  env.PUPPETEER_SKIP_DOWNLOAD = true;
  dontNpmBuild = true;

  meta = {
    changelog =
      "https://github.com/timostamm/protobuf-ts/releases/tag/v${version}";
    description = "Protobuf and RPC for Typescript";
    homepage = "https://github.com/timostamm/protobuf-ts";
    license = lib.licenses.asl20;
    mainProgram = "@protobuf-ts/plugin";
    maintainers = with lib.maintainers; [ ollieP ];
  };
}
