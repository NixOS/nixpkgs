{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  libGL,
  libGLU,
  SDL,
  SDL_mixer,
  bulletml,
}:

let
  version = "0.23a";
  debianRevision = "16";
  debianPatch =
    patchname: hash:
    fetchpatch {
      name = "${patchname}.patch";
      url = "https://sources.debian.org/data/main/r/rrootage/${version}-${debianRevision}/debian/patches/${patchname}.patch";
      inherit hash;
    };

in
stdenv.mkDerivation {
  pname = "rrootage";
  inherit version;
  src = fetchurl {
    url = "https://downloads.sourceforge.net/rrootage/rRootage-${version}.tar.gz";
    hash = "sha256-lk7b4hgC4+QNao2hm2ETLeys0Tv5pxushqvOASN5/wc=";
  };

  patches = [
    (debianPatch "01_makefile" "sha256-UkZ/Af3FTy4KFMbw4Vd+lKq7mr/0Yj61QOvN1O2n93E=")
    (debianPatch "02_data_dir" "sha256-A9t3a1U+52xNUkA3h+l/xxNYSpmFzIumccMvkjQwfIs=")
    (debianPatch "03_texture_filename" "sha256-UM6bb0fpbIUY3MpHHBggziLJB4m1CMeUVbsHgYzvs+M=")
    (debianPatch "04_home" "sha256-v3GV8PEExjUi7GHVF1a6PviJkMH6E5qa/BKQHSlYJWg=")
    (debianPatch "05_gcc" "sha256-Ap3lCLyeN+8rhP+paNCmT6clZeAmCLPY0UvRmd16MBo=")
    (debianPatch "06_rrootage_highres" "sha256-6jG+7+zjdjn0gapRtJq0A1v2mufcWZPQGzt6MwSs0kU=")
    (debianPatch "07_use_system_bulletml" "sha256-Rxp6jncKwNdiSKPmljBUYWGo7A5TAlfR37qO/n2guus=")
    (debianPatch "08_windowed_mode" "sha256-QyzwHMyl9TMArq1aJ3YXEbniksGz7Ua+pvHZQsgj3U4=")
    (debianPatch "09_rootage_make_highres_default" "sha256-VwigGUdGWP8d4Lv06dbERlXmvBosxbYrrhLRTIpGH/8=")
    (debianPatch "10_deg_out_of_range" "sha256-UDGCV4epCDzKGd5w7CuChn8lGf52tp6kemHTTL4yJ/M=")
    (debianPatch "11_gcc_15" "sha256-CQSZh+7u8yocn7hn18u9FCFHARhuGeY3YDR13vNPW+A=")
  ];

  postPatch = ''
    substituteInPlace "src/screen.c" --replace "/usr/share/games/rrootage" "$out/share/games/rrootage"
    substituteInPlace "src/soundmanager.c" --replace "/usr/share/games/rrootage" "$out/share/games/rrootage"
    substituteInPlace "src/barragemanager.cc" --replace "/usr/share/games/rrootage" "$out/share/games/rrootage"
  '';

  buildInputs = [
    libGL
    libGLU
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
    runHook preInstall

    install -d "$out"/share/games
    cp -r rr_share "$out"/share/games/rrootage
    install -D src/rrootage "$out"/bin/rrootage

    install -D -m 644 readme.txt "$out"/share/licenses/rrootage/README.jp
    install -m 644 readme_e.txt "$out"/share/licenses/rrootage/README.en

    install -D -m 644 readme.txt "$out"/share/doc/rrootage/README.jp
    install -m 644 readme_e.txt "$out"/share/doc/rrootage/README.en
    install -m 644 readme_linux "$out"/share/doc/rrootage/README

    runHook postInstall
  '';

  meta = {
    description = "Abstract shooter created by Kenta Cho";
    mainProgram = "rrootage";
    homepage = "https://rrootage.sourceforge.net/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
