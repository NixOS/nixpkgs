{
  lib,
  stdenv,
  pkg-config,
  fetchFromGitHub,
  bmake,
  zlib,
  libbsd,
  curl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcgi";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = "kcgi";
    tag = "VERSION_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-XFcag1oRsw+Qu9tjJvRcg2gAg0E0wh3poI/2mksSok4=";
  };

  patchPhase = ''
    substituteInPlace configure \
      --replace-fail PREFIX=\"/usr/local\" PREFIX=
  '';

  nativeBuildInputs = [
    pkg-config
    bmake
  ];
  buildInputs = [ zlib ] ++ lib.optionals stdenv.hostPlatform.isLinux [ libbsd ];

  nativeCheckInputs = [ bmake ];
  checkInputs = [ curl ];
  doCheck = true;

  checkPhase = ''
    runHook preCheck

    bmake regress

    runHook postCheck
  '';

  dontAddPrefix = true;

  installFlags = [ "DESTDIR=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://kristaps.bsd.lv/kcgi";
    changelog = "https://kristaps.bsd.lv/kcgi/archive.html";
    description = "Minimal CGI and FastCGI library for C/C++";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "kfcgi";
  };
})
