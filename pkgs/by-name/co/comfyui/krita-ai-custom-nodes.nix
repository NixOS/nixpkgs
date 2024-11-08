##
# Krita.ai can use ComfyUI as a backend, but there are some required
# custom-nodes that must be configured beforehand.  See
# https://github.com/Acly/krita-ai-diffusion/wiki/ComfyUI-Setup for Krita's
# documentation on the topic.
{ custom-nodes }: with custom-nodes; [
  controlnet-aux
  inpaint-nodes
  ipadapter-plus
  reactor-node
  tooling-nodes
  ultimate-sd-upscale
]
