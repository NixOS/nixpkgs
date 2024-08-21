{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "dwmbar";
  version = "unstable-2021-12-22";

  src = fetchFromGitHub {
    owner = "thytom";
    repo = "dwmbar";
    rev = "574f5703c558a56bc9c354471543511255423dc7";
    sha256 = "sha256-IrelZpgsxq2dnsjMdh7VC5eKffEGRbDkZmZBD+tROPs=";
  };

  postPatch = ''
    substituteInPlace dwmbar \
      --replace 'DEFAULT_CONFIG_DIR="/usr/share/dwmbar"' "DEFAULT_CONFIG_DIR=\"$out/share/dwmbar\""
  '';

  installPhase = ''
    install -d $out/share/dwmbar
    cp -r modules $out/share/dwmbar/
    install -D -t $out/share/dwmbar/ config
    install -D -t $out/share/dwmbar/ bar.sh
    install -Dm755 -t $out/bin/ dwmbar
  '';

  meta = with lib; {
    homepage = "https://github.com/thytom/dwmbar";
    description = "Modular Status Bar for dwm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ baitinq ];
    platforms = platforms.linux;
    mainProgram = "dwmbar";
  };
}
