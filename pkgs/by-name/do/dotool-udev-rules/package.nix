{
  stdenv,
  nixosTests,
  dotool,
}:

## Usage
# In NixOS, set:
# programs.dotool = {
#   enable = true;
#   allowedUsers = [ "alice" ];
# };

stdenv.mkDerivation {
  pname = "dotool-udev-rules";
  inherit (dotool) version src;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D 80-dotool.rules $out/lib/udev/rules.d/80-dotool.rules

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) dotool;
  };

  meta = dotool.meta // {
    description = "UDev rules for dotool";
  };
}
