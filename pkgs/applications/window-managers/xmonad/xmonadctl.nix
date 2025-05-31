{
  stdenv,
  lib,
  ghcWithPackages,
  haskellPackages,
  ...
}:

let
  xmonadctlEnv = ghcWithPackages (self: [
    self.xmonad-contrib
    self.X11
  ]);
in
stdenv.mkDerivation {
  pname = "xmonadctl";

  inherit (haskellPackages.xmonad-contrib) src version;

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
    mainProgram = "xmonadctl";
    homepage = "https://github.com/xmonad/xmonad-contrib";
    license = licenses.bsd3;
    maintainers = [ maintainers.ajgrf ];
  };
}
