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
    rev = "refs/tags/${pname}-${version}";
    sha256 = "sha256-7+4XwsjzLBCQmHDYNwhlN4Yg3eL43GUEbq8ROtuP2Kw=";
  };

  cargoHash = "sha256-durb4RTzEun7HPeYfvDJpvO+6L7tNFmAxdIwINbwZrg=";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace "/bin/rm" "${coreutils}/bin/rm"
  '';

  nativeBuildInputs = [ installShellFiles ];

  # uses lots of absolute paths outside of the sandbox
  doCheck = false;

  postInstall = ''
    installManPage safe-rm.1
  '';

  meta = with lib; {
    description = "Tool intended to prevent the accidental deletion of important files";
    homepage = "https://launchpad.net/safe-rm";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "safe-rm";
  };
}
