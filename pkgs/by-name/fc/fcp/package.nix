{
  expect,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
  fetchpatch,
}:

rustPlatform.buildRustPackage rec {
  pname = "fcp";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "svetlitski";
    repo = "fcp";
    tag = "v${version}";
    sha256 = "0f242n8w88rikg1srimdifadhggrb2r1z0g65id60ahb4bjm8a0x";
  };

  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/Svetlitski/fcp/commit/1988f88be54a507b804b037cb3887fecf11bb571.patch";
      hash = "sha256-fafpy1tviT1rV+jv1Yxg6xEsFZ9qXWQi5LykagDA5xI=";
    })
    (fetchpatch {
      url = "https://github.com/Svetlitski/fcp/commit/89bcfc9aa1055dcf541da7a6477ffd3107023f48.patch";
      hash = "sha256-NJ9MMeWf6Ywu+p5uDSWWpAcb01PoMbuSAZ3Qxl9jEaY=";
    })
    ./0001-update-Cargo.lock.patch
  ];

  cargoHash = "sha256-WcbrHAgFTP5OtLI+T0d0BoIxG0MBJzPgjjgCWL2nPus=";

  nativeBuildInputs = [ expect ];

  # character_device fails with "File name too long" on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  postPatch = ''
    patchShebangs tests/*.exp
  '';

  meta = {
    description = "Significantly faster alternative to the classic Unix cp(1) command";
    homepage = "https://github.com/svetlitski/fcp";
    changelog = "https://github.com/svetlitski/fcp/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "fcp";
  };
}
