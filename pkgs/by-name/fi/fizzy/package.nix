{
  lib,
  stdenv,
  fetchFromGitHub,
  bundlerEnv,
  bundlerUpdateScript,
  ruby_3_4,
  makeWrapper,
  nodejs,
  thruster,
  sqlite,
  vips,
  openssl,
  libyaml,
  pkg-config,
  perl,
}:

let
  addDeps = nativeBuildInputs: buildInputs: attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs or [ ] ++ nativeBuildInputs;
    buildInputs = attrs.buildInputs or [ ] ++ buildInputs;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fizzy";
  version = "unstable-2026-03-03";

  src = fetchFromGitHub {
    owner = "basecamp";
    repo = "fizzy";
    rev = "6e3ee266ec28053bdc8f49aa5f72f16e638dd8a4";
    hash = "sha256-fWskgVBUgPIpeLI82UZrBmmYAKe0cCaMajQ+lZC//N0=";
  };

  rubyEnv = bundlerEnv {
    name = "fizzy-gems-${finalAttrs.version}";
    ruby = ruby_3_4;
    gemdir = finalAttrs.src;
    gemset = ./gemdir/gemset.nix;
    gemConfig = {
      mittens = addDeps [ perl ] [ ];
      psych = addDeps [ pkg-config ] [ libyaml ];
      openssl =
        attrs:
        (addDeps [ pkg-config ] [ ] attrs)
        // {
          buildFlags = (attrs.buildFlags or [ ]) ++ [
            "--with-openssl-include=${openssl.dev}/include"
            "--with-openssl-lib=${openssl.out}/lib"
          ];
        };
      trilogy = addDeps [ pkg-config ] [ openssl ];
      sqlite3 =
        attrs:
        (addDeps [ pkg-config ] [ sqlite ] attrs)
        // {
          buildFlags = [
            "--with-sqlite3-include=${sqlite.dev}/include"
            "--with-sqlite3-lib=${sqlite.out}/lib"
          ];
        };
    };
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    finalAttrs.rubyEnv
    sqlite
    vips
    openssl
  ];

  env = {
    RAILS_ENV = "production";
    BUNDLE_WITHOUT = "development:test";
  };

  buildPhase = ''
    runHook preBuild

    patchShebangs bin/

    bundle exec bootsnap precompile --gemfile app/ lib/
    SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r --no-preserve=mode,ownership . "$out"/

    runHook postInstall
  '';

  postInstall = ''
    makeWrapper $out/bin/thrust $out/bin/fizzy-server \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
          thruster
        ]
      } \
      --set-default RAILS_ENV production \
      --set BUNDLE_GEMFILE ${finalAttrs.rubyEnv.confFiles}/Gemfile \
      --set GEM_HOME ${finalAttrs.rubyEnv}/${ruby_3_4.gemPath} \
      --set GEM_PATH ${finalAttrs.rubyEnv}/${ruby_3_4.gemPath} \
      --add-flags "$out/bin/rails server"

    for exe in rails rake thrust; do
      wrapProgram $out/bin/$exe \
        --prefix PATH : ${
          lib.makeBinPath [
            nodejs
            thruster
          ]
        } \
        --set-default RAILS_ENV production \
        --set BUNDLE_GEMFILE ${finalAttrs.rubyEnv.confFiles}/Gemfile \
        --set GEM_HOME ${finalAttrs.rubyEnv}/${ruby_3_4.gemPath} \
        --set GEM_PATH ${finalAttrs.rubyEnv}/${ruby_3_4.gemPath}
    done
  '';

  passthru = {
    updateScript = bundlerUpdateScript "fizzy";
  };

  meta = {
    description = "Kanban tracking tool for issues and ideas by 37signals";
    longDescription = ''
      Fizzy is an open-source Kanban tracking tool for issues and ideas,
      originally built and used by 37signals. It supports multi-tenancy,
      SQLite and MySQL, web push notifications (VAPID), and deployment
      via Kamal or Docker.
    '';
    homepage = "https://fizzy.do/";
    changelog = "https://github.com/basecamp/fizzy/releases";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "fizzy-server";
    platforms = lib.platforms.unix;
  };
})
