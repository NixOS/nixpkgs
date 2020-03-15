{ stdenv, rustPlatform, fetchFromGitHub, gtk, webkitgtk }:

rustPlatform.buildRustPackage rec {
  pname = "gnvim-unwrapped";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "vhakulinen";
    repo = "gnvim";
    rev = version;
    sha256 = "11gb59lhc1sp5dxj2fdm6072f4nxxay0war3kmchdwsk41nvxlrh";
  };

  cargoSha256 = "0ay7hx5bzchp772ywgxzia12c44kbyarrshl689cmqh59wphsrx5";

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
