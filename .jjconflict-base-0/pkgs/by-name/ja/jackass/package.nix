{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  pkg-config,
  wine64,
  enableJackAssWine64 ? false,
}:

let
  # equal to vst-sdk in ../oxefmsynth/default.nix
  vst-sdk = stdenv.mkDerivation (finalAttrs: {
    name = "vstsdk3610_11_06_2018_build_37";
    src = fetchzip {
      url = "https://web.archive.org/web/20181016150224if_/https://download.steinberg.net/sdk_downloads/${finalAttrs.name}.zip";
      hash = "sha256-cjYakxnqSDqSZ32FPK3OUhDpslOlavHh5SAVpng0QTU=";
    };
    installPhase = ''
      runHook preInstall
      cp -r . $out
      runHook postInstall
    '';
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "jackass";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "falkTX";
    repo = "JackAss";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6mqG4H6iGvDbGnmMeP/vcvSnvUGClZUl06XpKovt50E=";
  };

  postPatch = ''
    cp -r ${vst-sdk}/VST2_SDK/{public.sdk,pluginterfaces} vstsdk2.4
  '';

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals enableJackAssWine64 [ wine64 ];

  makeFlags = [ "linux" ] ++ lib.optionals enableJackAssWine64 [ "wine64" ];

  installPhase = ''
    runHook preInstall

    install_dir="$out/lib/vst"
    mkdir -p $install_dir
    for file in JackAss.so JackAssWine64.dll; do
      if test -f "$file"; then
        cp $file $install_dir
      fi
    done

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "JackAss is a VST plugin that provides JACK-MIDI support for VST hosts";
    longDescription = ''
      Simply load the plugin in your favourite host to get a JACK-MIDI port.
      Optionally includes a special Wine build for running in Wine
      applications. Set enableJackAssWine64 to true to enable this output.
    '';
    homepage = "https://github.com/falkTX/JackAss";
    maintainers = with maintainers; [ PowerUser64 ];
    license = with licenses; [
      mit
      unfree
    ];
    platforms = platforms.linux;
  };
})
