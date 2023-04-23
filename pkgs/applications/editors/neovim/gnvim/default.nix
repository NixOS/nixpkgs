{ lib, rustPlatform, fetchFromGitHub, gtk, webkitgtk }:

rustPlatform.buildRustPackage rec {
  pname = "gnvim-unwrapped";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "vhakulinen";
    repo = "gnvim";
    rev = "v${version}";
    sha256 = "1cc3yk04v9icdjr5cn58mqc3ba1wqmlzhf9ly7biy9m8yk30w9y0";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nvim-rs-0.1.1-alpha.0" = "sha256-wn68Lix3zZULrg/G4hP+OSj1GbEZMsA/+PaOlG9WLtc=";
    };
  };

  buildInputs = [ gtk webkitgtk ];

  # The default build script tries to get the version through Git, so we
  # replace it
  postPatch = ''
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

    # Install the binary ourselves, since the Makefile doesn't have the path
    # containing the target architecture
    sed -e "/target\/release/d" -i Makefile
  '';

  postInstall = ''
    make install PREFIX="${placeholder "out"}"
  '';

  meta = with lib; {
    description = "GUI for neovim, without any web bloat";
    homepage = "https://github.com/vhakulinen/gnvim";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
