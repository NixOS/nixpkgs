{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  vst2-sdk,
  wine64,
  enableJackAssWine64 ? false,
}:

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
    cp -r ${vst2-sdk}/{public.sdk,pluginterfaces} vstsdk2.4
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

  meta = {
    description = "VST plugin that provides JACK-MIDI support for VST hosts";
    longDescription = ''
      Simply load the plugin in your favourite host to get a JACK-MIDI port.
      Optionally includes a special Wine build for running in Wine
      applications. Set enableJackAssWine64 to true to enable this output.
    '';
    homepage = "https://github.com/falkTX/JackAss";
    maintainers = with lib.maintainers; [ PowerUser64 ];
    license = [ lib.licenses.mit ];
    platforms = lib.platforms.linux;
  };
})
