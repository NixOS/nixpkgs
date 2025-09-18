{
  lib,
  fetchFromGitHub,
  buildRubyGem,
  bundlerEnv,
  ruby_3_4,
}:

let
  gemName = "github-linguist";
  version = "9.1.0";
  src = fetchFromGitHub {
    owner = "github-linguist";
    repo = "linguist";
    tag = "v${version}";
    hash = "sha256-nPIUo6yQY6WvKuXvT1oOx6LZq49QLa9YIJmOrRYgAdg=";
  };

  deps = bundlerEnv {
    name = "github-linguist-dep";
    gemfile = "${src}/Gemfile";
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    inherit ruby;
  };

  ruby = ruby_3_4;

in
buildRubyGem rec {
  name = "${gemName}-${version}";
  inherit
    gemName
    version
    src
    ruby
    ;

  doInstallCheck = true;
  dontBuild = false;

  postInstall = ''
    export GEM_PATH="${deps}/lib/ruby/gems/${ruby.version.libDir}"
    bundle exec rake samples
    install --mode=0644 -Dm 0755 lib/linguist/samples.json $out/lib/ruby/gems/${ruby.version.libDir}/gems/${name}/lib/linguist

    wrapProgram "$out/bin/github-linguist" \
      --set GEM_PATH "${deps}/lib/ruby/gems/${ruby.version.libDir}"

    wrapProgram "$out/bin/git-linguist" \
      --set GEM_PATH "${deps}/lib/ruby/gems/${ruby.version.libDir}"
  '';

  passthru = {
    inherit ruby deps;
  };

  meta = {
    description = "Language savant Ruby library";
    longDescription = ''
      A Ruby library that is used on GitHub.com to detect blob languages, ignore binary or vendored files, suppress generated files in diffs, and generate language breakdown graphs.
    '';
    homepage = "https://github.com/github-linguist/linguist";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Cryolitia ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
