{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  unzip,
  gdc,
  SDL,
  SDL_mixer,
  bulletml,
}:

let
  debianPatch =
    patchname: hash:
    fetchpatch {
      name = "${patchname}.patch";
      url = "https://sources.debian.org/data/main/t/torus-trooper/0.22.dfsg1-12/debian/patches/${patchname}.patch";
      sha256 = hash;
    };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "torus-trooper";
  version = "0.22";

  src = fetchurl {
    url = "http://abagames.sakura.ne.jp/windows/tt${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }.zip";
    sha256 = "1yhki1fdp3fi4y2iq12vca69f6k38dqjaw9z4lwcxky5kbgb7jvg";
  };

  patches = [
    (debianPatch "imports" "0mifw0mj66zljpq6iqnh0rhkgs2sky8rz0p32k98vxfnsb39ibsf")
    (debianPatch "fixes" "05f93zq2v14lymq748c9g646ckbh9mqpr5rrahb63s90x8hlcqil")
    (debianPatch "directories" "0y5xvf26v9fk0rx6ncrxx4czckhjbi891hp3pixlmv568pg9cihd")
    (debianPatch "windowed" "1d8ghj4shvpb0s8l16kscz4l7rz1fxmfdpddy1ikz3678pw1sc8p")
    (debianPatch "dotfile" "17yirmnjhbd1clzhmdd2mfdhbxkyinaahd6v3yz5kzbcylvjz2r2")
    (debianPatch "window-resizing" "1n64gbhabl6vis7s294wxlj2k8s3ypxljpdg71icwz1m9jjx59df")
    (debianPatch "save-score-444372" "1skny6s3hjxkh8w4fq86vp51j7z40fvn80b8myl4i1zzlwag3x17")
    (debianPatch "level-select-444948" "008248s55188plggg2kg01nimjgc7w0sqd3c22sl6lzd1fjsflv8")
    (debianPatch "avoid-segfault-when-sdl-fails" "1yp758gi4i15gqk6wiqp815rqcmlyqx62ir1sw20hn6zb3j97bmc")
    (debianPatch "dlang_v2" "1lxsbckhvl8a8j43pw2dyl5nlavvdbgxb5zlb2450a0vml55nswd")
    (debianPatch "lowest-level-position-602808" "19r48wirc9zssjmv57drn2fd0f56dcgyqqaz3j49cvv6yd74qf20")
    (debianPatch "libbulletml0v5-segfault" "0pad2daz60hswkhkdpssxaqc9p9ca0sw1nraqzr453x0zdwwq0hn")
    (debianPatch "std.math.fabs" "18xnnqlj20bxv2h9fa8dn4rmxwi3k6y3g50kwvh8i8p3b4hgag3r")
    (debianPatch "gdc-8" "10z702y75c48hjcnvv8m7f3ka52cj3r3jqafdbby85nb0p2lbssx")
  ];

  postPatch = ''
    for f in src/abagames/tt/barrage.d src/abagames/util/sdl/sound.d src/abagames/util/sdl/texture.d; do
      substituteInPlace $f \
        --replace "/usr/" "$out/"
    done
  '';

  nativeBuildInputs = [
    unzip
    gdc
  ];

  buildInputs = [
    SDL
    SDL_mixer
    bulletml
  ];

  installPhase = ''
    install -Dm755 torus-trooper $out/bin/torus-trooper
    mkdir -p $out/share/games/torus-trooper
    cp -r barrage sounds images $out/share/games/torus-trooper/
  '';

  meta = with lib; {
    homepage = "http://www.asahi-net.or.jp/~cs8k-cyu/windows/tt_e.html";
    description = "Fast-paced abstract scrolling shooter game";
    mainProgram = "torus-trooper";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
})
