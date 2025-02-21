{
  lib,
  chromium,
  fontconfig,
  makeWrapper,
}:

let
  mkChromiumDerivation = chromium.passthru.mkDerivation.override {
    ungoogled = false;
    pulseSupport = false;
    cupsSupport = false;
    proprietaryCodecs = false;
    useSystemLibffi = false;
  };

in

mkChromiumDerivation (base: rec {
  name = "headless_shell";
  packageName = "chromium-headless-shell";
  buildTargets = [
    "chrome_sandbox"
    "headless_shell"
  ];

  outputs = [ "out" ];

  nativeBuildInputs = [ makeWrapper ] ++ base.nativeBuildInputs;

  gnFlags = {
    ### Copy the contents of build/args/headless.gn, as docker-headless-shell does ###
    ### Doesn't seem possible to just emit an import for that file ###
    use_ozone = true;
    ozone_auto_platforms = false;
    ozone_platform = "headless";
    ozone_platform_headless = true;
    angle_enable_vulkan = true;
    angle_enable_swiftshader = true;

    # Embed resource.pak into binary to simplify deployment.
    headless_use_embedded_resources = true;
    headless_enable_commands = false;

    # Don't use Prefs component, disabling access to Local State prefs.
    headless_use_prefs = false;

    # Don't use Policy component, disabling all policies.
    headless_use_policy = false;

    # Remove a dependency on a system fontconfig library.
    use_bundled_fontconfig = true;

    # In order to simplify deployment we build ICU data file
    # into binary.
    icu_use_data_file = false;

    # Use embedded data instead external files for headless in order
    # to simplify deployment.
    v8_use_external_startup_data = false;

    enable_nacl = false;
    enable_print_preview = false;
    enable_remoting = false;
    use_alsa = false;
    use_bluez = false;
    use_cups = false;
    use_dbus = false;
    use_gio = false;
    use_kerberos = false;
    use_libpci = false;
    use_pulseaudio = false;
    use_udev = false;
    rtc_use_pipewire = false;
    v8_enable_lazy_source_positions = false;
    use_glib = false;
    use_gtk = false;
    use_pangocairo = false;

    # Extra stuff inspired by docker-headless-shell
    is_debug = false;
    symbol_level = 0;
    blink_symbol_level = 0;
  };

  installPhase = ''
    mkdir -p $out/bin

    cd "$buildPath"

    cp -a ./{headless_shell,chrome_sandbox} $out/bin
    cp -a *.so $out/bin

    rm $out/bin/libEGL.so
    rm $out/bin/libGLESv2.so

    cd $out/bin
    mv chrome_sandbox chrome-sandbox
    mv headless_shell headless-shell

    wrapProgram $out/bin/headless-shell \
      --set CHROME_DEVEL_SANDBOX $out/bin/chrome-sandbox \
      --set FONTCONFIG_PATH "${fontconfig.out}/etc/fonts/"

    chmod -x *.so
  '';

  dontFixup = true;
  postFixup = null;

  sandboxExecutableName = "chrome-sandbox";

  passthru = { inherit sandboxExecutableName; };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "An open source web browser from Google";
    longDescription = ''
      Chromium is an open source web browser from Google that aims to build a
      safer, faster, and more stable way for all Internet users to experience
      the web. It has a minimalist user interface and provides the vast majority
      of source code for Google Chrome (which has some additional features).
    '';
    homepage = "https://www.chromium.org/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thomasjm ];
    mainProgram = "chromium";
  };
})
