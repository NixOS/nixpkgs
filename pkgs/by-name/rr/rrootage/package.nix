{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  SDL,
  SDL_mixer,
  bulletml,
}:

let
  version = "0.23a";
  debianRevision = "12";
  debianPatch =
    patchname: hash:
    fetchpatch {
      name = "${patchname}.patch";
      url = "https://sources.debian.org/data/main/r/rrootage/${version}-${debianRevision}/debian/patches/${patchname}.patch";
      sha256 = hash;
    };

in
stdenv.mkDerivation {
  pname = "rrootage";
  inherit version;
  src = fetchurl {
    url = "http://downloads.sourceforge.net/rrootage/rRootage-${version}.tar.gz";
    sha256 = "01zzg4ih3kmbhsn1p9zr7g8srv1d2dhrp8cdd86y9qq233idnkln";
  };

  patches = [
    (debianPatch "01_makefile" "0wgplznx9kgb82skwqplpydbpallgrby3w662h52wky5zl0pyijj")
    (debianPatch "02_data_dir" "12vw60s94by3f6k8pk45k555h4y7gzlqfds0a96nrrryammpgnq3")
    (debianPatch "03_texture_filename" "1qxkxy6821xvanacf25mi43wj8nf40c1qiyavhc8av798xprpkjh")
    (debianPatch "04_home" "0s15b0liv40jzjd9l4zsq688ky1yp9b1gmb1xhi3bih4y7q9awdz")
    (debianPatch "05_gcc" "06ihgbfrklabs7cb6216w1jjb9sglv86iagzhhmyydwyph4fb782")
    (debianPatch "06_rrootage_highres" "0ifjmh236yiv3g896nfwwydgcnq3njdb8ldah7s3jxp3xkpvwcga")
    (debianPatch "07_use_system_bulletml" "1sxsl1yzx3msvz8mf0jk1vnahqb1ahq9drm391idgh0afy77l6j7")
    (debianPatch "08_windowed_mode" "0knx4g445ngilsz4dvdkq69f5f8i2xv2fnmdmq037xd5rhfg0b23")
    (debianPatch "09_rootage_make_highres_default" "1zqz8s54rl8jmqmvdi9c3ayfcma6qkbfkx5vw0fzyn268wcs022p")
    (debianPatch "10_deg_out_of_range" "1wr76az4rlv1gaj9xdknzqcjazw6h8myqw6y3753q259hxbq4cah")
  ];
  postPatch = ''
    substituteInPlace "src/screen.c" --replace "/usr/share/games/rrootage" "$out/share/games/rrootage"
    substituteInPlace "src/soundmanager.c" --replace "/usr/share/games/rrootage" "$out/share/games/rrootage"
    substituteInPlace "src/barragemanager.cc" --replace "/usr/share/games/rrootage" "$out/share/games/rrootage"
  '';

  buildInputs = [
    SDL
    SDL_mixer
    bulletml
  ];
  makeFlags = [
    "-C src"
    "-f makefile.lin"
  ];
  hardeningDisable = [
    "stackprotector"
    "fortify"
  ]; # buffer overflow without this

  installPhase = ''
    install -d "$out"/share/games
    cp -r rr_share "$out"/share/games/rrootage
    install -D src/rrootage "$out"/bin/rrootage

    install -D -m 644 readme.txt "$out"/share/licenses/rrootage/README.jp
    install -m 644 readme_e.txt "$out"/share/licenses/rrootage/README.en

    install -D -m 644 readme.txt "$out"/share/doc/rrootage/README.jp
    install -m 644 readme_e.txt "$out"/share/doc/rrootage/README.en
    install -m 644 readme_linux "$out"/share/doc/rrootage/README
  '';

  meta = with lib; {
    description = "Abstract shooter created by Kenta Cho";
    mainProgram = "rrootage";
    homepage = "https://rrootage.sourceforge.net/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
  };
}
