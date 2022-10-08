{ stdenv, lib, fetchFromGitHub, ghcWithPackages, ... }:

let xmonadctlEnv = ghcWithPackages (self: [ self.xmonad-contrib self.X11 ]);
in stdenv.mkDerivation rec {
  pname = "xmonadctl";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "xmonad";
    repo = "xmonad-contrib";
    rev = "v${version}";
    sha256 = "sha256-KsotlGCqhJ/zJ8YZn0KIyx8/SuoLaTa2gK4Uxgq21fM=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ${xmonadctlEnv}/bin/ghc -o $out/bin/xmonadctl \
      --make scripts/xmonadctl.hs
    runHook postInstall
  '';

  meta = with lib; {
    platforms = platforms.unix;
    description = "Send commands to a running instance of xmonad";
    homepage = "https://github.com/xmonad/xmonad-contrib";
    license = licenses.bsd3;
    maintainers = [ maintainers.ajgrf ];
  };
}
