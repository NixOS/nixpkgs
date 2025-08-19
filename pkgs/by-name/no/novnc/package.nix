{
  lib,
  python3,
  stdenv,
  replaceVars,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "novnc";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "novnc";
    repo = "noVNC";
    rev = "v${version}";
    sha256 = "sha256-VYG0p70ZvRzK9IeA+5J95FqF+zWgj/8EcxnVOk+YL9o=";
  };

  patches =
    with python3.pkgs;
    [
      (replaceVars ./websockify.patch {
        inherit websockify;
      })
    ]
    ++ [ ./fix-paths.patch ];

  postPatch = ''
    substituteAllInPlace utils/novnc_proxy
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 utils/novnc_proxy "$out/bin/novnc"
    install -dm755 "$out/share/webapps/novnc/"
    cp -a app core po vendor vnc.html karma.conf.js package.json vnc_lite.html "$out/share/webapps/novnc/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "VNC client web application";
    homepage = "https://novnc.com";
    license = with licenses; [
      mpl20
      ofl
      bsd3
      bsd2
      mit
    ];
    maintainers = with maintainers; [ neverbehave ];
    mainProgram = "novnc";
  };
}
