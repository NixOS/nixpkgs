{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, libX11
, libXrandr
}:

stdenv.mkDerivation  {
  pname = "spice-autorandr";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "seife";
    repo = "spice-autorandr";
    rev = "0f61dc921b638761ee106b5891384c6348820b26";
    hash = "sha256-eBvzalWT3xI8+uNns0/ZyRes91ePpj0beKb8UBVqo0E=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libX11 libXrandr ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $pname $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "Automatically adjust the client window resolution in Linux KVM guests using the SPICE driver.";
    longDescription = ''
      Some desktop environments update the display resolution automatically,
      this package is only useful when running without a DE or with a DE that
      does not update display resolution automatically.

      This package relies on `spice-vdagent` running an updating the xrandr modes. Enable
      `spice-vdagent` by adding `services.spice-autorandr.enable = true` to your `configuration.nix`.
    '';
    homepage = "https://github.com/seife/spice-autorandr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmytrokyrychuk
    ];
    platforms = [ "x86_64-linux" ];
  };
}
