{
  lib,
  python3,
  stdenv,
  replaceVars,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "novnc";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "novnc";
    repo = "noVNC";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vObaEjP8ZgA4a4bEYbSBsSTl6CfYa/B7qmghM+iVDnQ=";
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
    cp -a app core po vendor vnc.html karma.conf.cjs package.json vnc_lite.html "$out/share/webapps/novnc/"

    runHook postInstall
  '';

  meta = {
    description = "VNC client web application";
    homepage = "https://novnc.com";
    license = with lib.licenses; [
      mpl20
      ofl
      bsd3
      bsd2
      mit
    ];
    maintainers = with lib.maintainers; [ neverbehave ];
    mainProgram = "novnc";
  };
})
