{ rustPlatform
, fetchFromGitHub
, lib
, fd
, libqalculate
}:

rustPlatform.buildRustPackage rec {
  pname = "pop-launcher";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "launcher";
    rev = version;
    sha256 = "sha256-BQAO9IodZxGgV8iBmUaOF0yDbAMVDFslKCqlh3pBnb0=";
  };

  postPatch = ''
    substituteInPlace src/lib.rs \
        --replace '/usr/lib/pop-launcher' "$out/share/pop-launcher"
    substituteInPlace plugins/src/scripts/mod.rs \
        --replace '/usr/lib/pop-launcher' "$out/share/pop-launcher"
    substituteInPlace plugins/src/calc/mod.rs \
        --replace 'Command::new("qalc")' 'Command::new("${libqalculate}/bin/qalc")'
    substituteInPlace plugins/src/find/mod.rs \
        --replace 'spawn("fd")' 'spawn("${fd}/bin/fd")'
    substituteInPlace plugins/src/terminal/mod.rs \
        --replace '/usr/bin/gnome-terminal' 'gnome-terminal'
  '';

  cargoHash = "sha256-cTvrq0fH057UIx/O9u8zHMsg+psMGg1q9klV5OMxtok=";

  cargoBuildFlags = [ "--package" "pop-launcher-bin" ];

  postInstall = ''
    mv $out/bin/pop-launcher{-bin,}

    plugins_dir=$out/share/pop-launcher/plugins
    scripts_dir=$out/share/pop-launcher/scripts
    mkdir -p $plugins_dir $scripts_dir

    for plugin in $(find plugins/src -mindepth 1 -maxdepth 1 -type d -printf '%f\n'); do
      mkdir $plugins_dir/$plugin
      cp plugins/src/$plugin/*.ron $plugins_dir/$plugin
      ln -sf $out/bin/pop-launcher $plugins_dir/$plugin/$(echo $plugin | sed 's/_/-/')
    done

    for script in scripts/*; do
      cp -r $script $scripts_dir
    done
  '';

  meta = with lib; {
    description = "Modular IPC-based desktop launcher service";
    homepage = "https://github.com/pop-os/launcher";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ samhug ];
    mainProgram = "pop-launcher";
  };
}
