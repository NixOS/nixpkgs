# Export templates is necessary for setting up Godot engine, it's used when exporting projects.
# Godot applications/games packages needs to reference export templates.
# Export templates version should be kept in sync with Godot version.
# https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html#export-templates

{ fetchzip, godot4, ... }:

fetchzip {
  pname = "export_templates";
  extension = "zip";
  url = "https://github.com/godotengine/godot/releases/download/${godot4.version}/Godot_v${godot4.version}_export_templates.tpz";
  hash = "sha256-eomGLH9lbZhl7VtHTWjJ5mxVt0Yg8LfnAnpqoCksPgs=";
}
