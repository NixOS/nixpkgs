{ stdenv, rustPlatform, fetchFromGitHub, gtk, webkitgtk }:

rustPlatform.buildRustPackage rec {
  pname = "gnvim-unwrapped";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "vhakulinen";
    repo = "gnvim";
    rev = "v${version}";
    sha256 = "1cc3yk04v9icdjr5cn58mqc3ba1wqmlzhf9ly7biy9m8yk30w9y0";
  };

  cargoSha256 = "1fyn8nsabzrfl9ykf2gk2p8if0yjp6k0ybrmp0pw67pbwaxpb9ym";

  buildInputs = [ gtk webkitgtk ];

  # The default build script tries to get the version through Git, so we
  # replace it
  prePatch = ''
    cat << EOF > build.rs
    use std::env;
    use std::fs::File;
    use std::io::Write;
    use std::path::Path;

    fn main() {
        let out_dir = env::var("OUT_DIR").unwrap();
        let dest_path = Path::new(&out_dir).join("gnvim_version.rs");
        let mut f = File::create(&dest_path).unwrap();
        f.write_all(b"const VERSION: &str = \"${version}\";").unwrap();
    }
    EOF
  '';

  buildPhase = ''
    make build
  '';

  installPhase = ''
    make install PREFIX="${placeholder "out"}"
  '';

  meta = with stdenv.lib; {
    description = "GUI for neovim, without any web bloat";
    homepage = "https://github.com/vhakulinen/gnvim";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
