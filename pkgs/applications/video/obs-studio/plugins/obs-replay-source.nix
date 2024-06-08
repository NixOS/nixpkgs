{ stdenv
, lib
, fetchFromGitHub
, cmake
, libcaption
, obs-studio
, qtbase
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-replay-source";
  version = "1.6.13-unstable-2024-02-03";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-replay-source";
    rev = "6590fde1c8e4f8c733016646a8165d52e28d094b";
    hash = "sha256-foIzWNlU72FWXZVWR8TEiqJJMfl1vWYDTyhV6thYJbA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libcaption obs-studio qtbase ];

  postInstall = ''
    mkdir -p "$out/lib" "$out/share"
    mv "$out/obs-plugins/64bit" "$out/lib/obs-plugins"
    rm -rf "$out/obs-plugins"
    mv "$out/data" "$out/share/obs"
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Replay source for OBS studio";
    homepage = "https://github.com/exeldro/obs-replay-source";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pschmitt ];
  };
})
