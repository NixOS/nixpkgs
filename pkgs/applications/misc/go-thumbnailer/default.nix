{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, vips
}:

buildGoModule rec {
  pname = "go-thumbnailer";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = pname;
    rev = version;
    sha256 = "sha256-sgd5kNnDXcSesGT+OignZ+APjNSxSP0Z60dr8cWO6sU=";
  };

  buildInputs = [
    vips
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  vendorSha256 = "sha256-4zgsoExdhEqvycGerNVxZ6LnjeRRO+f6DhJdINR5ZyI=";

  postInstall = ''
    mkdir -p $out/share/thumbnailers
    substituteAll ${./go.thumbnailer} $out/share/thumbnailers/go.thumbnailer
  '';

  meta = with lib; {
    description = "A cover thumbnailer written in Go for performance and reliability";
    homepage = "https://github.com/donovanglover/go-thumbnailer";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
  };
}
