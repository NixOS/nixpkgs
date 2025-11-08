{
  lib,
  bundlerApp,
  makeWrapper,
  ruby,
  writeShellScriptBin,
  withOptionalDependencies ? false,
}:

let
  rubyWrapper = writeShellScriptBin "ruby" ''
    if [[ "$#" -eq 2 ]]; then
      if [[ "''${1##*/}" == "bundle" && "$2" == "install" ]]; then
        # See https://github.com/NixOS/nixpkgs/issues/58126 for more details.
        echo 'Skipping "bundle install" as it fails due to the Nix wrapper.'
        echo 'Please enter the new directory and run the following commands to serve the page:'
        echo 'nix-shell -p bundler --run "bundle install --gemfile=Gemfile --path vendor/cache"'
        echo 'nix-shell -p bundler --run "bundle exec jekyll serve"'
        exit 0
        # The following nearly works:
        unset BUNDLE_FROZEN
        exec ${ruby}/bin/ruby "$@" --gemfile=Gemfile --path=vendor/cache
      fi
    fi
    # Else: Don't modify the arguments:
    exec ${ruby}/bin/ruby "$@"
  '';
in
bundlerApp {
  pname = "jekyll";
  exes = [ "jekyll" ];

  inherit ruby;
  gemdir = if withOptionalDependencies then ./full else ./basic;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/jekyll --prefix PATH : ${rubyWrapper}/bin
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Blog-aware, static site generator, written in Ruby";
    longDescription = ''
      Jekyll is a simple, blog-aware, static site generator, written in Ruby.
      Think of it like a file-based CMS, without all the complexity. Jekyll
      takes your content, renders Markdown and Liquid templates, and spits out a
      complete, static website ready to be served by Apache, Nginx or another
      web server. Jekyll is the engine behind GitHub Pages, which you can use to
      host sites right from your GitHub repositories.
    '';
    homepage = "https://jekyllrb.com/";
    changelog = "https://jekyllrb.com/news/releases/";
    license = licenses.mit;
    maintainers = [ maintainers.anthonyroussel ];
    platforms = platforms.unix;
    mainProgram = "jekyll";
  };
}
