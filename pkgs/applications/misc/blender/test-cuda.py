import bpy

preferences = bpy.context.preferences.addons["cycles"].preferences
devices = preferences.get_devices_for_type("CUDA")
ids = [d.id for d in devices]

assert any("CUDA" in i for i in ids), f"CUDA not present in {ids}"
print("CUDA is available")
