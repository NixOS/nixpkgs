{
  lib,
  fetchFromGitHub,
  writeShellScript,
  dash,
  php,
  phpCfg ? null,
  withPostgreSQL ? true, # “strongly recommended” according to docs
  withMariaDB ? false,
  minifyStaticFiles ? false, # default files are often not minified
  esbuild,
  lightningcss,
  scour,
  nixosTests,
}:

let
  defaultMinifyOpts = {
    script = {
      enable = false;
      target = "es2020";
    };
    style = {
      enable = false;
      browserslist = "defaults, Firefox ESR, Firefox 91, last 20 Firefox major versions, last 20 Chrome major versions, last 3 Safari major versions, last 1 KaiOS version, and supports css-variables";
    };
    svg = {
      enable = false;
    };
  };

  minify = lib.recursiveUpdate defaultMinifyOpts (
    if lib.isBool minifyStaticFiles && minifyStaticFiles then
      {
        script.enable = true;
        style.enable = true;
        svg.enable = true;
      }
    else if lib.isAttrs minifyStaticFiles then
      lib.filterAttrsRecursive (_: v: v != null) minifyStaticFiles
    else
      { }
  );
in
php.buildComposerProject2 (finalAttrs: {
  pname = "movim";
  version = "0.31";

  src = fetchFromGitHub {
    owner = "movim";
    repo = "movim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rW751UhDBhakOrAT4BOiRDPpGldf1EwNZY8iavXlpLk=";
  };

  php = php.buildEnv (
    {
      extensions = (
        { all, enabled }:
        enabled
        ++ [
          all.curl
          all.dom
          all.gd
          all.imagick
          all.mbstring
          all.pdo
          all.simplexml
        ]
        ++ lib.optionals withPostgreSQL [
          all.pdo_pgsql
          all.pgsql
        ]
        ++ lib.optionals withMariaDB [
          all.mysqli
          all.mysqlnd
          all.pdo_mysql
        ]
      );
    }
    // lib.optionalAttrs (phpCfg != null) {
      extraConfig = phpCfg;
    }
  );

  nativeBuildInputs =
    lib.optional minify.script.enable esbuild
    ++ lib.optional minify.style.enable lightningcss
    ++ lib.optional minify.svg.enable scour;

  vendorHash = "sha256-Ke+bh/mvKUk5qxjlBZo4jJhLneyFRq0HYXTwK/KZMBs=";

  postPatch = ''
    # Our modules are already wrapped, removes missing *.so warnings;
    # replacing `$configuration` with actually-used flags.
    substituteInPlace src/Movim/Daemon/Session.php \
      --replace-fail \
        "'exec ' . PHP_BINARY . ' ' . \$configuration . '" \
        "'exec ' . PHP_BINARY . ' -dopcache.enable=1 -dopcache.enable_cli=1 ' . '"

    # Point to PHP + PHP INI in the Nix store
    substituteInPlace src/Movim/Console/DaemonCommand.php \
      --replace-fail "<info>php vendor/bin/phinx migrate</info>" \
        "<info>${lib.getBin finalAttrs.php} vendor/bin/phinx migrate</info>" \
      --replace-fail "<info>php daemon.php setAdmin {jid}</info>" \
        "<info>${finalAttrs.meta.mainProgram} setAdmin {jid}</info>"

    # BUGFIX: Imagick API Changes for 7.x+
    # See additionally: https://github.com/movim/movim/pull/1122
    substituteInPlace src/Movim/Image.php \
      --replace-fail "Imagick::ALPHACHANNEL_REMOVE" "Imagick::ALPHACHANNEL_OFF" \
      --replace-fail "Imagick::ALPHACHANNEL_ACTIVATE" "Imagick::ALPHACHANNEL_ON"
  '';

  preBuild =
    lib.optionalString minify.script.enable
      # sh
      ''
        find ./public -type f -iname "*.js" -print0 \
          | xargs -0 -n 1 -P $NIX_BUILD_CORES ${writeShellScript "movim_script_minify" ''
            file="$1"
            tmp="$(mktemp)"
            esbuild $file --minify --target=${lib.escapeShellArg minify.script.target} --outfile=$tmp
            [ "$(stat -c %s $tmp)" -lt "$(stat -c %s $file)" ] && mv $tmp $file
          ''}
      ''
    +
      lib.optionalString minify.style.enable
        # sh
        ''
          find ./public -type f -iname "*.css" -print0 \
            | xargs -0 -n 1 -P $NIX_BUILD_CORES ${writeShellScript "movim_style_minify" ''
              export BROWSERLIST="${lib.escapeShellArg minify.style.browserslist}"
              file="$1"
              tmp="$(mktemp)"
              lightningcss $file --minify --browserslist --output-file=$tmp
              [ "$(stat -c %s $tmp)" -lt "$(stat -c %s $file)" ] && mv $tmp $file
            ''}
        ''
    +
      lib.optionalString minify.svg.enable
        # sh
        ''
          find ./public -type f -iname "*.svg" -a -not -path "*/emojis/*" -print0 \
            | xargs -0 -n 1 -P $NIX_BUILD_CORES ${writeShellScript "movim_svg_minify" ''
              file="$1"
              tmp="$(mktemp)"
              scour -i $file -o $tmp --disable-style-to-xml --enable-comment-stripping --enable-viewboxing --indent=tab
              [ "$(stat -c %s $tmp)" -lt "$(stat -c %s $file)" ] && mv $tmp $file
            ''}
        '';

  postInstall = ''
    mkdir -p $out/bin
    cat << EOF > $out/bin/movim
    #!${lib.getExe dash}
    ${lib.getExe finalAttrs.php} $out/share/php/movim/daemon.php "\$@"
    EOF
    chmod +x $out/bin/movim

    mkdir -p \
      $out/share/bash-completion/completion \
      $out/share/fish/vendor_completions.d \
      $out/share/zsh/site-functions
    $out/bin/movim completion bash | sed "s/daemon.php/movim/g" > $out/share/bash-completion/completion/movim.bash
    $out/bin/movim completion fish | sed "s/daemon.php/movim/g" > $out/share/fish/vendor_completions.d/movim.fish
    $out/bin/movim completion zsh | sed "s/daemon.php/movim/g" > $out/share/zsh/site-functions/_movim

    chmod +x \
      $out/share/bash-completion/completion/movim.bash \
      $out/share/fish/vendor_completions.d/movim.fish \
      $out/share/zsh/site-functions/_movim
  '';

  passthru = {
    tests = { inherit (nixosTests) movim; };
  };

  meta = {
    description = "Federated blogging & chat platform that acts as a web front end for the XMPP protocol";
    homepage = "https://movim.eu";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ toastal ];
    mainProgram = "movim";
  };
})
