{ lib, buildPythonApplication, fetchFromGitHub, pythonOlder, file, fetchpatch
, cairo, ffmpeg, sox, xdg_utils, texlive
, colour, numpy, pillow, progressbar, scipy, tqdm, opencv , pycairo, pydub
, pbr, fetchPypi
}:
buildPythonApplication rec {
  pname = "manim";
  version = "0.1.10";

  src = fetchPypi {
    pname = "manimlib";
    inherit version;
    sha256 = "0vg9b3rwypq5zir74pi0pmj47yqlcg7hrvscwrpjzjbqq2yihn49";
  };

  patches = [ ./remove-dependency-constraints.patch ];

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    colour
    numpy
    pillow
    progressbar
    scipy
    tqdm
    opencv
    pycairo
    pydub

    cairo sox ffmpeg xdg_utils
  ];

  # Test with texlive to see whether it works but don't propagate
  # because it's huge and optional
  # TODO: Use smaller TexLive distribution
  #       Doesn't need everything but it's hard to figure out what it needs
  checkInputs = [ cairo sox ffmpeg xdg_utils texlive.combined.scheme-full ];

  # Simple test and complex test with LaTeX
  checkPhase = ''
    for scene in SquareToCircle OpeningManimExample
    do
      python3 manim.py example_scenes.py $scene -l
      tail -n 20 files/Tex/*.log  # Print potential LaTeX erorrs
      ${file}/bin/file videos/example_scenes/480p15/$scene.mp4 \
        | tee | grep -F "ISO Media, MP4 Base Media v1 [IS0 14496-12:2003]"
    done
  '';

  disabled = pythonOlder "3.7";

  meta = {
    description = "Animation engine for explanatory math videos";
    longDescription = ''
      Manim is an animation engine for explanatory math videos. It's used to
      create precise animations programmatically, as seen in the videos of
      3Blue1Brown on YouTube.
    '';
    homepage = https://github.com/3b1b/manim;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johnazoidberg ];
  };
}
