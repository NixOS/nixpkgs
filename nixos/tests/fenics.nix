import ./make-test-python.nix ({ pkgs, ... }:

let
  fenicsScript = pkgs.writeScript "poisson.py" ''
    #!/usr/bin/env python
    from dolfin import *

    mesh = UnitSquareMesh(4, 4)
    V = FunctionSpace(mesh, "Lagrange", 1)

    def boundary(x):
        return x[0] < DOLFIN_EPS or x[0] > 1.0 - DOLFIN_EPS

    u0 = Constant(0.0)
    bc = DirichletBC(V, u0, boundary)

    u = TrialFunction(V)
    v = TestFunction(V)
    f = Expression("10*exp(-(pow(x[0] - 0.5, 2) + pow(x[1] - 0.5, 2)) / 0.02)", degree=2)
    g = Expression("sin(5*x[0])", degree=2)
    a = inner(grad(u), grad(v))*dx
    L = f*v*dx + g*v*ds

    u = Function(V)
    solve(a == L, u, bc)
    print(u)
  '';
in
{
  name = "fenics";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ knedlsepp ];
  };

  nodes = {
    fenicsnode = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        gcc
        (python3.withPackages (ps: with ps; [ fenics ]))
      ];
    };
  };
  testScript =
    { nodes, ... }:
    ''
      start_all()
      fenicsnode.succeed("${fenicsScript}")
    '';
})
