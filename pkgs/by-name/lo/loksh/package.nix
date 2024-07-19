{ lib
, stdenv
, fetchFromGitHub
, meson
, ncurses
, ninja
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loksh";
  version = "7.5";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "loksh";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-4cBO1FXUnN/swwEeM2lq5RJJGmLKInMLZkz942EKy6k=";
  };

  outputs = [ "out" "doc" "man" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    ncurses
  ];

  strictDeps = true;

  postInstall = ''
    mv $out/bin/ksh $out/bin/loksh
    pushd $man/share/man/man1/
    mv ksh.1 loksh.1
    mv sh.1 loksh-sh.1
    popd
  '';

  passthru = {
    shellPath = "/bin/loksh";
  };

  meta = {
    homepage = "https://github.com/dimkr/loksh";
    description = "Linux port of OpenBSD's ksh";
    mainProgram = "loksh";
    longDescription = ''
      loksh is a Linux port of OpenBSD's ksh.

      Unlike other ports of ksh, loksh targets only one platform, follows
      upstream closely and keeps changes to a minimum. loksh does not add any
      extra features; this reduces the risk of introducing security
      vulnerabilities and makes loksh a good fit for resource-constrained
      systems.
    '';
    license = with lib.licenses; [ publicDomain ];
    maintainers = with lib.maintainers; [ AndersonTorres cameronnemo ];
    platforms = lib.platforms.linux;
  };
})
