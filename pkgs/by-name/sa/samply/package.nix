{
  lib,
  rustPlatform,
  fetchCrate,
  jq,
  moreutils,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "samply";
  version = "0.12.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7bf1lDIZGhRpvnn8rHNwzH2GBY8CwtYCjuRAUTQgbsA=";
  };

  cargoHash = "sha256-QGvtKx+l6+UxdlziHnF63geAvW55RRlatK2/J8LR0Ck=";

  # the dependencies linux-perf-data and linux-perf-event-reader contains both README.md and Readme.md,
  # which causes a hash mismatch on systems with a case-insensitive filesystem
  # this removes the readme files and updates cargo's checksum file accordingly
  depsExtraArgs = {
    nativeBuildInputs = [
      jq
      moreutils
    ];

    postBuild = ''
      for crate in linux-perf-data linux-perf-event-reader; do
        pushd $name/$crate

        rm -f README.md Readme.md
        jq 'del(.files."README.md") | del(.files."Readme.md")' \
          .cargo-checksum.json -c \
          | sponge .cargo-checksum.json

        popd
      done
    '';
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "Command line profiler for macOS and Linux";
    mainProgram = "samply";
    homepage = "https://github.com/mstange/samply";
    changelog = "https://github.com/mstange/samply/releases/tag/samply-v${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
