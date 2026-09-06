{
  lib,
  rustPlatform,
  fetchFromGitea,
  deno,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hurrycurry-server";
  version = "3.0.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "hurrycurry";
    repo = "hurrycurry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HUxuM4H7DGn4DmxioUwBZN8+b6ro5JBWnqS3oBR4nH4=";
  };

  postPatch = ''
    substituteInPlace server/src/main.rs \
      --replace-fail '/usr/local/share/hurrycurry/data' "$out/share/hurrycurry/data"
    # Don't rely on makefile to compile rust programs
    substituteInPlace makefile \
      --replace-fail 'target/release' "$out/bin"
    patchShebangs --build data/recipes/anticurry.sed
  '';

  cargoHash = "sha256-7SzzVxw4r/+5s3cYP20vnSe/DWpcn1BCqMOt0T3865k=";

  nativeBuildInputs = [ deno ];

  # server/discover/src/main.rs:18:1 #![feature(never_type)]
  env.RUSTC_BOOTSTRAP = true;

  postBuild = ''
    make all_data
  '';

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags = [ "--skip=test::packet_sender_verif" ];

  dontUseCargoParallelTests = true; # Race condition in creating scoreboard

  postInstall = ''
    mkdir -p $out/share/hurrycurry
    cp -r data $out/share/hurrycurry/
    rm $out/share/hurrycurry/data/recipes/{default.js,anticurry.sed,*~}
  '';

  meta = {
    description = "Cooperative 3D multiplayer game about cooking";
    homepage = "https://hurrycurry.org";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "hurrycurry-server";
  };
})
