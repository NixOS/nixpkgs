# Languages and frameworks {#chap-language-support}

The [standard build environment](#chap-stdenv) makes it easy to build typical Autotools-based packages with very little code. Any other kind of package can be accomodated by overriding the appropriate phases of `stdenv`. However, there are specialised functions in Nixpkgs to easily build packages for other programming languages, such as Perl or Haskell. These are described in this chapter.
