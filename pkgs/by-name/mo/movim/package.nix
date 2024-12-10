{
  lib,
  fetchFromGitHub,
  writeShellScript,
  dash,
  php,
  phpCfg ? null,
  withPgsql ? true, # “strongly recommended” according to docs
  withMysql ? false,
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
      target = "es2021";
    };
    style = {
      enable = false;
      browserslist = "defaults, Firefox ESR, last 20 Firefox major versions, last 20 Chrome major versions, last 3 Safari major versions, last 1 KaiOS version, and supports css-variables";
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
php.buildComposerProject (finalAttrs: {
  pname = "movim";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "movim";
    repo = "movim";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Ai82d1VwtAlKmM8N/hazMWsn5F6HS4I1do3VkpLPlBo=";
  };

  php = php.buildEnv (
    {
      extensions = (
        { all, enabled }:
        enabled
        ++ (with all; [
          curl
          dom
          gd
          imagick
          mbstring
          pdo
          simplexml
        ])
        ++ lib.optionals withPgsql (
          with all;
          [
            pdo_pgsql
            pgsql
          ]
        )
        ++ lib.optionals withMysql (
          with all;
          [
            mysqli
            mysqlnd
            pdo_mysql
          ]
        )
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

  # no listed license
  # pinned commonmark
  composerStrictValidation = false;

  vendorHash = "sha256-1sQm+eRrs9m52CepPXahsOJhyLZ68+FIDNHyY33IoD4=";

  postPatch = ''
    # Our modules are already wrapped, removes missing *.so warnings;
    # replacing `$configuration` with actually-used flags.
    substituteInPlace src/Movim/Daemon/Session.php \
      --replace-fail "exec php ' . \$configuration " "exec php -dopcache.enable=1 -dopcache.enable_cli=1 ' "

    # Point to PHP + PHP INI in the Nix store
    substituteInPlace src/Movim/{Console/DaemonCommand.php,Daemon/Session.php} \
      --replace-fail "exec php " "exec ${lib.getExe finalAttrs.php} "
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
    lib.optionalString minify.script.enable ''
      find ./public -type f -iname "*.js" -print0 \
        | xargs -0 -n 1 -P $NIX_BUILD_CORES ${writeShellScript "movim_script_minify" ''
          file="$1"
          tmp="$(mktemp)"
          esbuild $file --minify --target=${lib.escapeShellArg minify.script.target} --outfile=$tmp
          [[ "$(stat -c %s $tmp)" -lt "$(stat -c %s $file)" ]] && mv $tmp $file
        ''}
    ''
    + lib.optionalString minify.style.enable ''
      find ./public -type f -iname "*.css" -print0 \
        | xargs -0 -n 1 -P $NIX_BUILD_CORES ${writeShellScript "movim_style_minify" ''
          export BROWSERLIST="${lib.escapeShellArg minify.style.browserslist}"
          file="$1"
          tmp="$(mktemp)"
          lightningcss $file --minify --browserslist --output-file=$tmp
          [[ "$(stat -c %s $tmp)" -lt "$(stat -c %s $file)" ]] && mv $tmp $file
        ''}
    ''
    + lib.optionalString minify.svg.enable ''
      find ./public -type f -iname "*.svg" -a -not -path "*/emojis/*" -print0 \
        | xargs -0 -n 1 -P $NIX_BUILD_CORES ${writeShellScript "movim_svg_minify" ''
          file="$1"
          tmp="$(mktemp)"
          scour -i $file -o $tmp --disable-style-to-xml --enable-comment-stripping --enable-viewboxing --indent=tab
          [[ "$(stat -c %s $tmp)" -lt "$(stat -c %s $file)" ]] && mv $tmp $file
        ''}
    '';

  postInstall = ''
    mkdir -p $out/bin
    echo "#!${lib.getExe dash}" > $out/bin/movim
    echo "${lib.getExe finalAttrs.php} $out/share/php/${finalAttrs.pname}/daemon.php \"\$@\"" >> $out/bin/movim
    chmod +x $out/bin/movim

    mkdir -p $out/share/{bash-completion/completion,fish/vendor_completions.d,zsh/site-functions}
    $out/bin/movim completion bash | sed "s/daemon.php/movim/g" > $out/share/bash-completion/completion/movim.bash
    $out/bin/movim completion fish | sed "s/daemon.php/movim/g" > $out/share/fish/vendor_completions.d/movim.fish
    $out/bin/movim completion zsh | sed "s/daemon.php/movim/g" > $out/share/zsh/site-functions/_movim
    chmod +x $out/share/{bash-completion/completion/movim.bash,fish/vendor_completions.d/movim.fish,zsh/site-functions/_movim}
  '';

  passthru = {
    tests = { inherit (nixosTests) movim; };
  };

  meta = {
    description = "a federated blogging & chat platform that acts as a web front end for the XMPP protocol";
    homepage = "https://movim.eu";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ toastal ];
    mainProgram = "movim";
  };
})
