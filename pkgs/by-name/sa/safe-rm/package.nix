{
  lib,
  rustPlatform,
  fetchgit,
  coreutils,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "safe-rm";
  version = "1.1.0";

  src = fetchgit {
    url = "https://git.launchpad.net/safe-rm";
    tag = "${pname}-${version}";
    sha256 = "sha256-7+4XwsjzLBCQmHDYNwhlN4Yg3eL43GUEbq8ROtuP2Kw=";
  };

  cargoHash = "sha256-6mPx7qgrsUtjDiFMIL4NTmG9jeC3mBlsQIf/TUB4SQM=";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail "/bin/rm" "${coreutils}/bin/rm"
  '';

  nativeBuildInputs = [ installShellFiles ];

  # uses lots of absolute paths outside of the sandbox
  doCheck = false;

  postInstall = ''
    installManPage safe-rm.1
  '';

  meta = {
    description = "Tool intended to prevent the accidental deletion of important files";
    homepage = "https://launchpad.net/safe-rm";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "safe-rm";
  };
}
