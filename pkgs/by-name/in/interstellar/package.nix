{
  lib,
  flutter335,
  fetchFromGitHub,
  imagemagick,
  alsa-lib,
  libass,
  mpv-unwrapped,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
}:

let
  pname = "interstellar";

<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "interstellar-app";
    repo = "interstellar";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-5CFl5pvxentbKCPHkPDj4d5i3d2S3UxkQ56OX14Y8gY=";
=======
    hash = "sha256-nlzTYLJSFKMdPIZ1WX4ZrT8ZBw3gd3Y2o1mmc1DH9Rs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in
flutter335.buildFlutterApplication {
  inherit pname version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [ imagemagick ];

  buildInputs = [
    alsa-lib
    libass
    mpv-unwrapped
  ];

  # run build_runner to make model .part files and language locale gen
  preBuild = ''
    packageRun build_runner build --delete-conflicting-outputs
  '';

  postInstall = ''
    for size in 16 22 24 32 36 48 64 72 96 128 192 256 512 1024; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick $src/assets/icons/logo.png -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/interstellar.png
    done
    install -D --mode=0644 linux/appimage/interstellar.desktop --target-directory $out/share/applications
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/${pname}/lib
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "interstellar.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
    ];
  };

  meta = {
    description = "App for Mbin/Lemmy/PieFed, connecting you to the fediverse";
    homepage = "https://interstellar.jwr.one";
    license = lib.licenses.agpl3Plus;
    mainProgram = "interstellar";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ JollyDevelopment ];
  };
}
