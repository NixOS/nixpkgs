{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nitrokey-udev-rules";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-udev-rules";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LKpd6O9suAc2+FFgpuyTClEgL/JiZiokH3DV8P3C7Aw=";
  };

  # The repository already contains the generated rules.  Building would only
  # re-generate them.
  dontBuild = true;
  # The check target only checks the Python code that is not used by this
  # package, not the actual rules.
  doCheck = false;

  installPhase = ''
    install -D 41-nitrokey.rules -t $out/etc/udev/rules.d
  '';

  meta = with lib; {
    description = "udev rules for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/nitrokey-udev-rules";
    license = [ licenses.cc0 ];
    maintainers = with maintainers; [
      frogamic
      robinkrahl
    ];
  };
})
