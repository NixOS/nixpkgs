import sys

from paraview.simple import GetActiveViewOrCreate, Render, SaveScreenshot, Show, Sphere
from vtkmodules.vtkIOImage import vtkPNGReader

out = sys.argv[1]

Show(Sphere())
view = GetActiveViewOrCreate("RenderView")
Render(view)

window = view.GetRenderWindow()

# Guard against a silent fallback to another window class (X11, OSMesa).
assert window.GetClassName() == "vtkEGLRenderWindow", window.GetClassName()

assert SaveScreenshot(out, view, ImageResolution=[64, 64])
reader = vtkPNGReader()
reader.SetFileName(out)
reader.Update()
low, high = reader.GetOutput().GetPointData().GetScalars().GetRange()
assert high > low, "rendered image is uniform"
