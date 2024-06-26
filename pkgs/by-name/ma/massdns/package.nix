{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "massdns";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "blechschmidt";
    repo = "massdns";
    rev = "v${version}";
    hash = "sha256-hrnAg5ErPt93RV4zobRGVtcKt4aM2tC52r08T7+vRGc=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "PROJECT_FLAGS=-DMASSDNS_REVISION='\"v${version}\"'"
  ];
  buildFlags = if stdenv.isLinux then "all" else "nolinux";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Resolve large amounts of domain names";
    homepage = "https://github.com/blechschmidt/massdns";
    changelog = "https://github.com/blechschmidt/massdns/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ geoffreyfrogeye ];
    mainProgram = "massdns";
    platforms = platforms.all;
    # error: use of undeclared identifier 'MSG_NOSIGNAL'
    badPlatforms = platforms.darwin;
  };
}
