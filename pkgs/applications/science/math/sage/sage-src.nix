{ stdenv
, fetchFromGitHub
, fetchpatch
}:
stdenv.mkDerivation rec {
  version = "8.2";
  name = "sage-src-${version}";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "0d7vc16s7dj23an2cb8v5bhbnc6nsw20qhnnxr0xh8qg629027b8";
  };

  nixPatches = [
    # https://trac.sagemath.org/ticket/25309
    (fetchpatch {
      name = "spkg-paths.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=97f06fddee920399d4fcda65aa9b0925774aec69&id=a86151429ccce1ddd085e8090ada8ebdf02f3310";
      sha256 = "1xb9108rzzkdhn71vw44525620d3ww9jv1fph5a77v9y7nf9wgr7";
    })
    (fetchpatch {
      name = "maxima-fas.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=97f06fddee920399d4fcda65aa9b0925774aec69";
      sha256 = "14s50yg3hpw9cp3v581dx7zfmpm2j972im7x30iwki8k45mjvk3i";
    })

    # https://trac.sagemath.org/ticket/25328
    # https://trac.sagemath.org/ticket/25546
    # https://trac.sagemath.org/ticket/25722
    (fetchpatch {
      name = "install-jupyter-kernel-in-correct-prefix.patch";
      url = "https://git.sagemath.org/sage.git/patch?id=72167b98e3f64326df6b2c78785df25539472fcc";
      sha256 = "0pscnjhm7r2yr2rxnv4kkkq626vwaja720lixa3m3w9rwlxll5a7";
    })
    ./patches/test-in-tmpdir.patch

    # https://trac.sagemath.org/ticket/25358
    (fetchpatch {
      name = "safe-directory-test-without-patch.patch";
      url = "https://git.sagemath.org/sage.git/patch?id2=8bdc326ba57d1bb9664f63cf165a9e9920cc1afc&id=dc673c17555efca611f68398d5013b66e9825463";
      sha256 = "1hhannz7xzprijakn2w2d0rhd5zv2zikik9p51i87bas3nc658f7";
    })

    # https://trac.sagemath.org/ticket/25357 rebased on 8.2
    ./patches/python3-syntax-without-write.patch

    # https://trac.sagemath.org/ticket/25314
    (fetchpatch {
      name = "make-qepcad-test-optional.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=fe294c58bd035ef427e268901d54a6faa0058138";
      sha256 = "003d5baf5c0n5rfg010ijwkwz8kg0s414cxwczs2vhdayxdixbix";
    })

    # https://trac.sagemath.org/ticket/25316
    ./patches/python-5755-hotpatch.patch

    # https://trac.sagemath.org/ticket/25354
    # https://trac.sagemath.org/ticket/25531
    (fetchpatch {
      name = "cysignals-include.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=28778bd25a37c80884d2b24e0683fb2989300cef";
      sha256 = "0fiiiw91pgs8avm9ggj8hb64bhqzl6jcw094d94nhirmh8w2jmc5";
    })

    # https://trac.sagemath.org/ticket/25315
    (fetchpatch {
      name = "find-libraries-in-dyld-library-path.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=20d4593876ce9c6004eac2ab6fd61786d0d96a06";
      sha256 = "1k3afq3qlzmgqwx6rzs5wv153vv9dsf5rk8pi61g57l3r3npbjmc";
    })

    # Pari upstream has since accepted a patch, so this patch won't be necessary once sage updates pari.
    # https://trac.sagemath.org/ticket/25312
    ./patches/pari-stackwarn.patch

    # https://trac.sagemath.org/ticket/25311
    ./patches/zn_poly_version.patch

    # https://trac.sagemath.org/ticket/25345
    # (upstream patch doesn't apply on 8.2 source)
    ./patches/dochtml-optional.patch
  ];

  packageUpgradePatches = [
    (fetchpatch {
      name = "cypari2-1.2.1.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=62fe6eb15111327d930336d4252d5b23cbb22ab9";
      sha256 = "1xax7vvs8h4xip16xcsp47xdb6lig6f2r3pl8cksvlz8lhgbyxh2";
    })

    # matplotlib 2.2.2 deprecated `normed` (replaced by `density`).
    # This patch only ignores the warning. It would be equally easy to fix it
    # (by replacing all mentions of `normed` by `density`), but its better to
    # stay close to sage upstream. I didn't open an upstream ticket about it
    # because the matplotlib update also requires a new dependency (kiwisolver)
    # and I don't want to invest the time to learn how to add it.
    ./patches/matplotlib-normed-deprecated.patch

    # Update to 20171219 broke the doctests because of insignificant precision
    # changes, make the doctests less fragile.
    # I didn't open an upstream ticket because its not entirely clear if
    # 20171219 is really "released" yet. It is listed on the github releases
    # page, but not marked as "latest release" and the homepage still links to
    # the last version.
    ./patches/eclib-regulator-precision.patch

    # sphinx 1.6 -> 1.7 upgrade
    # https://trac.sagemath.org/ticket/24935
    ./patches/sphinx-1.7.patch

    # Adapt hashes to new boost version
    # https://trac.sagemath.org/ticket/22243
    # (this ticket doesn't only upgrade boost but also avoids this problem in the future)
    (fetchpatch {
      name = "boost-upgrade.patch";
      url = "https://git.sagemath.org/sage.git/patch?id=a24a9c6b30b93957333a3116196214a931325b69";
      sha256 = "0z3870g2ms2a81vnw08dc2i4k7jr62w8fggvcdwaavgd1wvdxwfl";
    })

    # gfan 0.6.2
    # https://trac.sagemath.org/ticket/23353
    (fetchpatch {
      name = "gfan-update.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=420215fc469cde733ec7a339e59b78ad6eec804c&id=112498a293ea2bf563e41aed35f1aa608f01b349";
      sha256 = "0ga3hkx8cr23dpc919lgvpi5lmy0d728jkq9z6kf0fl9s8g31mxb";
    })

    # New glpk version has new warnings, filter those out until upstream sage has found a solution
    # https://trac.sagemath.org/ticket/24824
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/sagemath/raw/58bbba93a807ca2933ca317501d093a1bb4b84db/debian/patches/dt-version-glpk-4.65-ignore-warnings.patch";
      sha256 = "0b9293v73wb4x13wv5zwyjgclc01zn16msccfzzi6znswklgvddp";
      stripLen = 1;
    })

    # https://trac.sagemath.org/ticket/25329
    (fetchpatch {
      name = "dont-check-exact-glpk-version.patch";
      url = "https://git.sagemath.org/sage.git/patch?id2=8bdc326ba57d1bb9664f63cf165a9e9920cc1afc&id=89d068d8d77316bfffa6bf8e9ebf70b3b3b88e5c";
      sha256 = "00knwxs6fmymfgfl0q5kcavmxm9sf90a4r76y35n5s55gj8pl918";
    })

    # https://trac.sagemath.org/ticket/25355
    (fetchpatch {
      name = "maxima-5.41.0.patch";
      url = "https://git.sagemath.org/sage.git/patch/?id=87328023c4739abdf24108038201e3fa9bdfc739";
      sha256 = "0hxi7qr5mfx1bc32r8j7iba4gzd7c6v63asylyf5cbyp86azpb7i";
    })

    # Update cddlib from 0.94g to 0.94h.
    # https://trac.sagemath.org/ticket/25341 (doesn't apply to 8.2 sources)
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/sagemath/raw/58bbba93a807ca2933ca317501d093a1bb4b84db/debian/patches/u2-version-cddlib-094h.patch";
      sha256 = "0fmw7pzbaxs2dshky6iw9pr8i23p9ih2y2lw661qypdrxh5xw03k";
      stripLen = 1;
    })
    (fetchpatch {
      name = "revert-cddlib-doctest-changes.patch";
      url = "https://git.sagemath.org/sage.git/patch/?id=269c1e1551285566b8ba7a2b890989e5590e9f11";
      sha256 = "12bcjhq7hm2pmmj2bgjvcffjyls2x7q61ivlnaj5v5bsvhc183iy";
      revert = true;
    })


    # Only formatting changes.
    # https://trac.sagemath.org/ticket/25260
    ./patches/numpy-1.14.3.patch

    # https://trac.sagemath.org/ticket/24374
    (fetchpatch {
      name = "networkx-2.1.patch";
      url = "https://salsa.debian.org/science-team/sagemath/raw/487df9ae48ca1d93d9b1cb3af8745d31e30fb741/debian/patches/u0-version-networkx-2.1.patch";
      sha256 = "1xxxawygbgxgvlv7b4w8hhzgdnva4rhmgdxaiaa3pwdwln0yc750";
      stripLen = 1;
    })

    # https://trac.sagemath.org/ticket/24927 rebased
    ./patches/arb-2.13.0.patch

    # https://trac.sagemath.org/ticket/24838 rebased
    ./patches/pynac-0.7.22.patch

    # https://trac.sagemath.org/ticket/25862
    ./patches/eclib-20180710.patch
  ];

  patches = nixPatches ++ packageUpgradePatches;

  postPatch = ''
    # make sure shebangs etc are fixed, but sage-python23 still works
    find . -type f -exec sed \
      -e 's/sage-python23/python/g' \
      -i {} \;

    echo '#!${stdenv.shell}
    python "$@"' > build/bin/sage-python23

    # Do not use sage-env-config (generated by ./configure).
    # Instead variables are set manually.
    echo '# do nothing' >  src/bin/sage-env-config
  '';

  configurePhase = "# do nothing";

  buildPhase = "# do nothing";

  installPhase = ''
    cp -r . "$out"
  '';
}
