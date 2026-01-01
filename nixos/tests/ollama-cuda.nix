<<<<<<< HEAD
{ lib, pkgs, ... }:
=======
{ lib, ... }:
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
{
  name = "ollama-cuda";
  meta.maintainers = with lib.maintainers; [ abysssol ];

  nodes.cuda =
    { ... }:
    {
      services.ollama.enable = true;
<<<<<<< HEAD
      services.ollama.package = pkgs.ollama-cuda;
=======
      services.ollama.acceleration = "cuda";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

  testScript = ''
    cuda.wait_for_unit("multi-user.target")
    cuda.wait_for_open_port(11434)
  '';
}
