{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook3
, keybinder3
}:

rustPlatform.buildRustPackage rec {
  pname = "findex";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "mdgaziur";
    repo = "findex";
    rev = "v${version}";
    hash = "sha256-rxOVrl2Q27z5oo1J6D4ft4fKaOMOadmidflD0jK0+3k=";
  };

  cargoHash = "sha256-MiD96suB88NZWg7Ay/ACZfOeE66WOe9dLsvtOhCQgGo=";

  postPatch = ''
    # failing rust documentation tests and faulty quotes "`README.md`"
    sed -i '/^\/\/\//d' ./crates/findex-plugin/src/lib.rs
    substituteInPlace ./crates/findex/src/gui/css.rs \
      --replace-fail '/opt/findex/style.css' "$out/share/findex/style.css"
  '';

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 ];

  buildInputs = [ keybinder3 ];

  postInstall = ''
    install -Dm644 css/style.css $out/share/findex/style.css
  '';

  meta = with lib; {
    description = "Highly customizable application finder written in Rust and uses Gtk3";
    homepage = "https://github.com/mdgaziur/findex";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.pinkcreeper100 ];
  };
}
