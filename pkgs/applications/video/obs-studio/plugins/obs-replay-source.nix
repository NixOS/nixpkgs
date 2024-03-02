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
  version = "1.6.13";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-replay-source";
    rev = finalAttrs.version;
    sha256 = "sha256-i64rpIVnUplA9AKZtR3xeByeawca7B00kGmEcKi7DWQ=";
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
