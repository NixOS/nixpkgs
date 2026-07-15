{
  lib,
  cacert,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dummyhttp";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dummyhttp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JfI6r1hSCZePzUFpmR1vBU4qHXAvfSL5snF/X2zfN4o=";
  };

  patches = [
    # https://github.com/svenstaro/dummyhttp/pull/557
    (fetchpatch {
      url = "https://github.com/svenstaro/dummyhttp/commit/3418c1b29f1fbb007c3b559901aa1927ba41de37.patch";
      hash = "sha256-jiDXuySZ+JRqqbx5zr5ES/OvxajQOsxj3DZ6AYGxkms=";
    })
  ];

  nativeBuildInputs = [
    cacert
  ];

  cargoHash = "sha256-klUifN8I0c7SnsH1V+LdUKJYimTnGV3QMRjEnUAVkfI=";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Super simple HTTP server that replies a fixed body with a fixed response code";
    homepage = "https://github.com/svenstaro/dummyhttp";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ tbutter ];
    mainProgram = "dummyhttp";
  };
})
