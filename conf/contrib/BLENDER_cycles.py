# Blender 2.75 Cycles Material Script
#
# Instruction
# -----------------------------------------------------------------------
#
# - Export with jmc2obj OBJ File and Textures (Alpha into seperate files!) into one folder
#   Now you've got the following Folder Structure
#
#   YourFolderName
#   |- tex (Folder)
#      |- a lot of png files
#   |- minecraft.obj
#   |- minecraft.mtl

# - Open Blender
# - Create new File
# - Save File into "YourFolderName" (important!)
# - Close Blender
# - Open Blender
# - Open your File
# - Import minecraft.obj
# - Switch to "Scripting"
# - Open this script
# - Press "Run Script"
#
# The script will set up cycles and all materials
#
# Save Blender File
# Begin your Work  :)
#
# Happy Rendering
#
# Ben
#
#

import re
import bpy


def doIt():
    context = bpy.context

    scene = context.scene
    render = scene.render
    world = scene.world

    # switch to cycles
    render.engine = 'CYCLES'

    # cycles
    world.cycles.sample_as_light = True
    world.cycles.sample_map_resolution = 1024
    world.cycles.homogeneous_volume = True

    # ambient occlusion
    world.light_settings.use_ambient_occlusion = True
    world.light_settings.ao_factor = 0.1
    world.light_settings.distance = 2

    # light path
    scene.cycles.transparent_max_bounces = 12
    scene.cycles.transparent_mix_bounces = 12
    scene.cycles.max_bounces = 12
    scene.cycles.min_bounces = 12

    scene.cycles.diffuse_bounces = 4
    scene.cycles.glossy_bounces = 4
    scene.cycles.transmission_bounces = 12
    scene.cycles.volume_bounces = 1

    scene.cycles.caustics_reflective = False
    scene.cycles.caustics_refractive = False

    # samples
    scene.cycles.samples = 500

    # random seed for animations
    scene.cycles.use_animated_seed = True;

    # clear environment
    world.use_nodes = True
    world.node_tree.nodes.clear()

    for slot in bpy.data.materials:
        try:
            mat = bpy.data.materials[slot.name]
        except KeyError:
            print(slot.name + ' not found...')
            continue

        diffuse_color = mat.diffuse_color

        mat.use_nodes = True
        mat.cycles.sample_as_light = True

        nodes = mat.node_tree.nodes
        links = mat.node_tree.links

        texImageFound = False
        texAlphaImageFound = False
        texName = re.sub('\.\d\d\d', '', slot.name)

        if texName == 'pumpkin_side_lit':
            texName = 'pumpkin_side'
        if texName == 'pumpkin_top_lit':
            texName = 'pumpkin_top'

        print('Set Material for: ' + slot.name + ' - ' + texName)

        for image in bpy.data.images:
            checkPath = '//tex/' + texName + '.png'
            checkPathAlpha = '//tex/' + texName + '_a.png'
            if image.filepath == checkPath:
                texImage = image
                texImageFound = True
            if image.filepath == checkPathAlpha:
                texImageAlpha = image
                texAlphaImageFound = True

        # specials
        if texName == 'armor_enchanted':
            armor_enchanted(nodes, links);
        else:
            if texImageFound == False:
                print('TexImage for ' + texName + ' not found!')
            else:
                # remove all default nodes
                nodes.clear()
                nTexAlpha = None
                nTex = None
                nOutput = nodes.new('ShaderNodeOutputMaterial')
                nOutput.location = (900.0, 0.0)

                mainShader = {
                    "sea_lantern": makeMcMainTranslucent,
                    "default": makeMcMainDiffuseTranslucent,
                    "tall_grass": makeMcMainTranslucent,
                    "torch_flame": makeMcMainTranslucent,
                    "double_plant_grass_bottom": makeMcMainTranslucent,
                    "double_plant_grass_top": makeMcMainTranslucent,
                    "double_plant_rose_bottom": makeMcMainTranslucent,
                    "double_plant_rose_top": makeMcMainTranslucent,
                    "double_plant_sunflower_bottom": makeMcMainTranslucent,
                    "double_plant_sunflower_front": makeMcMainTranslucent,
                    "double_plant_sunflower_top": makeMcMainTranslucent,
                    "flower_houstonia": makeMcMainTranslucent,
                    "flower_oxeyey_daisy": makeMcMainTranslucent,
                    "flower_red": makeMcMainTranslucent,
                    "flower_yellow": makeMcMainTranslucent,

                    "pumpkin_front_lit": makeMcMainTranslucent,
                    "pumpkin_side_lit": makeMcMainTranslucent,
                    "pumpkin_top_lit": makeMcMainTranslucent,

                    "glass": makeMcMainTranslucent,
                    "glass_orange": makeMcMainTranslucent,
                    "glass_pane_side_orange": makeMcMainTranslucent,
                    "glass_pane_side_white": makeMcMainTranslucent,
                    "glass_white": makeMcMainTranslucent,
                    "water": makeMcMainDiffuseTranslucent,

                    "armor_leather_feet_overlay": makeMcMainInvisible,

                    "armor_golden_helmet": makeMcMainGlossy,
                    "armor_golden_chest": makeMcMainGlossy,
                    "armor_golden_feet": makeMcMainGlossy,
                    "armor_golden_legs": makeMcMainGlossy,

                    "armor_iron_helmet": makeMcMainGlossy,
                    "armor_iron_chest": makeMcMainGlossy,
                    "armor_iron_feet": makeMcMainGlossy,
                    "armor_iron_legs": makeMcMainGlossy,

                    "wool_yellow": makeMcMainDiffuse,
                    "wool_orange": makeMcMainDiffuse
                }

                try:
                    nMainData = mainShader[texName](nodes, links)
                except KeyError:
                    nMainData = mainShader['default'](nodes, links)

                nMainData["node"].location = (400.0, 0.0)

                nTex = nodes.new(type='ShaderNodeTexImage')
                nTex.location = (0, 0.0)
                nTex.image = texImage
                nTex.interpolation = 'Closest'

                links.new(nTex.outputs['Color'], nMainData["input"])
                if (nMainData["input2"]):
                    links.new(nTex.outputs['Color'], nMainData["input2"])

                if texAlphaImageFound == True:
                    nTexAlpha = nodes.new(type='ShaderNodeTexImage')
                    nTexAlpha.location = (200.0, 300.0)
                    nTexAlpha.image = texImageAlpha
                    nTexAlpha.interpolation = 'Closest'

                    nTrans = nodes.new(type='ShaderNodeBsdfTransparent')
                    nTrans.location = (300.0, 100.0)

                    nMix = nodes.new(type='ShaderNodeMixShader');
                    nMix.location = (700.0, 0.0)

                    links.new(nMix.outputs['Shader'], nOutput.inputs['Surface'])
                    links.new(nMainData["output"], nMix.inputs[2])
                    links.new(nTrans.outputs['BSDF'], nMix.inputs[1])
                    links.new(nTexAlpha.outputs['Color'], nMix.inputs[0])

                    lastMixOut = nMix.outputs['Shader']
                else:
                    links.new(nMainData["output"], nOutput.inputs['Surface'])
                    lastMixOut = nMainData["output"]

                # emission demo (torches, sea_lantern, etc)
                if texName in ['sea_lantern', 'torch_flame', 'fire'] or \
                        ((texName.startswith('pumpkin_') and texName.endswith('_lit'))):
                    mat.cycles.sample_as_light = True

                    nOutput.location = (1300.0, 0.0)

                    nEmMix = nodes.new(type='ShaderNodeMixShader');
                    nEmMix.location = (900.0, 100.0)

                    nEmMix2 = nodes.new(type='ShaderNodeMixShader');
                    nEmMix2.location = (1100.0, 100.0)

                    nEmit = nodes.new(type='ShaderNodeEmission');
                    nEmit.location = (700, 150.0)
                    if texName == 'sea_lantern':
                        nEmit.inputs[0].default_value = (1, 1, 1, 1)
                        nEmit.inputs["Strength"].default_value = 5

                    if texName == 'torch_flame':
                        nEmit.inputs[0].default_value = (1, 0.25, 0, 1)
                        nEmit.inputs["Strength"].default_value = 30
                    if texName == 'fire':
                        nEmit.inputs[0].default_value = (1, 0.11, 0, 1)
                        nEmit.inputs["Strength"].default_value = 50
                    if (texName.startswith('pumpkin_')):
                        nEmit.inputs[0].default_value = (1, 0.46, 0, 1)
                        nEmit.inputs["Strength"].default_value = 7

                    nLp = nodes.new(type='ShaderNodeLightPath');
                    nLp.location = (700.0, 400.0)

                    links.new(lastMixOut, nEmMix.inputs[2])
                    links.new(lastMixOut, nEmMix2.inputs[1])
                    links.new(nEmMix.outputs['Shader'], nEmMix2.inputs[2])
                    links.new(nEmMix2.outputs['Shader'], nOutput.inputs['Surface'])
                    links.new(nEmit.outputs['Emission'], nEmMix.inputs[1])
                    links.new(nLp.outputs['Is Camera Ray'], nEmMix.inputs[0])
                    # links.new(nLp.outputs['Is Reflection Ray'], nEmMix2.inputs[0])

                    # in case of alpha is present at emission...
                    if nTexAlpha:
                        nTexAlpha.location = (00, 300.0)
                        nEmit.location = (250, 350.0)
                        nEmMixD = nodes.new(type='ShaderNodeMixShader');
                        nEmMixD.location = (500.0, 300.0)

                        links.new(nEmMixD.outputs['Shader'], nEmMix.inputs[1])
                        links.new(nTexAlpha.outputs['Color'], nEmMixD.inputs[0])
                        links.new(nEmit.outputs['Emission'], nEmMixD.inputs[2])
                        links.new(nTrans.outputs['BSDF'], nEmMixD.inputs[1])
                    else:
                        nDiff = nodes.new('ShaderNodeBsdfDiffuse')
                        nDiff.location = (400.0, -150.0)

                        nMatMix = nodes.new(type='ShaderNodeMixShader');
                        nMatMix.location = (650.0, -100.0)

                        if texName == 'sea_lantern':
                            nMatMix.inputs[0].default_value = 0.07

                        if texName.startswith('pumpkin_'):
                            nMatMix.inputs[0].default_value = 0.005

                        links.new(nTex.outputs['Color'], nDiff.inputs[0])

                        links.new(nEmit.outputs['Emission'], nMatMix.inputs[2])
                        links.new(nMainData["output"], nMatMix.inputs[1])

                        links.new(nMatMix.outputs['Shader'], nEmMix.inputs[2])
                        links.new(nMatMix.outputs['Shader'], nEmMix2.inputs[1])

                # glass special
                if texName.startswith('glass_') or texName == 'glass':
                    nOutput.location = (1900.0, 00.0)
                    nTex.location = (0.0, 0.0)
                    nTexAlpha.location = (0.0, 300.0)

                    nMainData['node'].location = (400.0, -100.0)
                    nTrans.location = (1400.0, 300.0)
                    nMix.location = (1600.0, 200.0)

                    # nTexMix = nodes.new(type='ShaderNodeMixShader');
                    # nTexMix.location = (1000.0, 200.0)

                    # links.new(nTexMix.outputs['Shader'], nMix.inputs[1])

                    nBright = nodes.new(type='ShaderNodeBrightContrast');
                    nBright.inputs['Bright'].default_value = 2
                    nBright.inputs['Contrast'].default_value = 7
                    nBright.location = (400.0, 300.0)

                    links.new(nTexAlpha.outputs['Color'], nBright.inputs[0])

                    nGlass = nodes.new(type='ShaderNodeBsdfGlass');
                    nGlass.location = (400.0, 100.0)
                    nGlass.inputs['IOR'].default_value = 1.45

                    # nGeometry = nodes.new(type='ShaderNodeNewGeometry');
                    # nGeometry.location = (1400.0, 550.0)

                    # links.new(nGeometry.outputs['Backfacing'], nMix.inputs[0])
                    # links.new(nTrans.outputs['BSDF'], nMix.inputs[2])

                    nGlossy = nodes.new(type='ShaderNodeBsdfGlossy');
                    nGlossy.location = (400.0, -250.0)
                    nGlossy.inputs[1].default_value = 0.133

                    # links.new(nTex.outputs['Color'], nGlass.inputs[0])
                    # links.new(nTex.outputs['Color'], nGlossy.inputs[0])

                    nAdd = nodes.new(type='ShaderNodeAddShader');
                    nAdd.location = (700.0, -200.0)

                    links.new(nMainData['output'], nAdd.inputs[0])
                    links.new(nGlossy.outputs['BSDF'], nAdd.inputs[1])

                    links.new(nBright.outputs['Color'], nMix.inputs[0])
                    links.new(nAdd.outputs['Shader'], nMix.inputs[2])
                    links.new(nGlass.outputs['BSDF'], nMix.inputs[1])

                    # nMix4 = nodes.new(type='ShaderNodeMixShader');
                    # nMix4.location = (1300.0, 200.0)

                    # nMix5 = nodes.new(type='ShaderNodeMixShader');
                    # nMix5.location = (1600.0, 200.0)

                    # nGeometry = nodes.new(type='ShaderNodeNewGeometry');
                    # nGeometry.location = (1100.0, 500.0)

                    # nLp = nodes.new(type='ShaderNodeLightPath');
                    # nLp.location = (1400.0, 500.0)

                    # links.new(nMix1.outputs['Shader'], nMix2.inputs[1])
                    # links.new(nMix2.outputs['Shader'], nMix.inputs[1])
                    # links.new(nMix.outputs['Shader'], nMix4.inputs[1])
                    # links.new(nMix4.outputs['Shader'], nMix5.inputs[1])
                    # links.new(nMix5.outputs['Shader'], nOutput.inputs['Surface'])

                    # links.new(nTrans.outputs['BSDF'], nMix1.inputs[1])
                    # links.new(nTrans.outputs['BSDF'], nMix2.inputs[2])
                    # links.new(nTrans.outputs['BSDF'], nMix4.inputs[2])
                    # links.new(nTrans.outputs['BSDF'], nMix5.inputs[2])

                    # links.new(nGeometry.outputs['Backfacing'], nMix4.inputs[0])
                    # links.new(nLp.outputs['Is Reflection Ray'], nMix5.inputs[0])
                    # links.new(nGlass.outputs['BSDF'], nMix1.inputs[2])

                    # links.new(nTex.outputs['Color'], nBright.inputs['Color'])
                    # links.new(nBright.outputs['Color'], nMainData["input"])
                    # links.new(nGlass.outputs['BSDF'], nAdd.inputs[0])
                    # links.new(lastMixOut, nAdd.inputs[1])
                    # links.new(nTexAlpha.outputs['Color'], nGlass.inputs['Color'])
                    # links.new(nAdd.outputs['Shader'], nOutput.inputs['Surface'])

                if ((texName.startswith('armor_')) and
                        (texName != 'armor_stand') and
                        (texName != 'armor_enchanted')
                    ):
                    if (texName.startswith('armor_leather')):
                        nTex.location = (-200.0, -200.0)
                        nMixRGB = nodes.new(type='ShaderNodeMixRGB');
                        nMixRGB.location = (000.0, 0.0)
                        nMixRGB.blend_type = 'VALUE'

                        nRGB = nodes.new(type='ShaderNodeRGB');
                        nRGB.location = (-200.0, 0.0);
                        nRGB.outputs[0].default_value = (diffuse_color.r, diffuse_color.g, diffuse_color.b, 1);
                        links.new(nTex.outputs['Color'], nMixRGB.inputs[2])
                        links.new(nRGB.outputs['Color'], nMixRGB.inputs[1])
                        links.new(nMixRGB.outputs['Color'], nMainData["input"])

                # water
                if texName == 'water':
                    nOutput.location = (1100.0, 0.0)

                    nMix.inputs[0].default_value = 0.25

                    nGloss = nodes.new(type='ShaderNodeBsdfGlossy');
                    nGloss.location = (700.0, 200.0)
                    nGloss.inputs[1].default_value = 0.005
                    # nGloss.inputs['IOR'].default_value = 1.33

                    nMixGloss = nodes.new(type='ShaderNodeMixShader');
                    nMixGloss.location = (900.0, 0.0)
                    nMixGloss.inputs[0].default_value = 0.85

                    links.new(lastMixOut, nMixGloss.inputs[2])
                    links.new(nMixGloss.outputs['Shader'], nOutput.inputs['Surface'])
                    links.new(nGloss.outputs['BSDF'], nMixGloss.inputs[1])

                    nWave = nodes.new(type='ShaderNodeTexWave');
                    nWave.location = (400.0, -200.0)
                    nWave.wave_type = 'RINGS'
                    nWave.inputs[1].default_value = 25
                    nWave.inputs[2].default_value = 10
                    nWave.inputs[3].default_value = 2.5

                    nNoise = nodes.new(type='ShaderNodeTexNoise');
                    nNoise.location = (400.0, -450.0)
                    nNoise.inputs[1].default_value = 100
                    nNoise.inputs[2].default_value = 1

                    nMixRGB = nodes.new(type='ShaderNodeMixRGB');
                    nMixRGB.blend_type = 'MULTIPLY'
                    nMixRGB.inputs[0].default_value = 0.4
                    nMixRGB.location = (700.0, -300.0)

                    links.new(nWave.outputs['Color'], nMixRGB.inputs[1])
                    links.new(nNoise.outputs['Color'], nMixRGB.inputs[2])
                    links.new(nMixRGB.outputs['Color'], nOutput.inputs['Displacement'])

                    nodes.remove(nTexAlpha)


def makeMcMainDiffuse(nodes, links):
    nMain = nodes.new('ShaderNodeBsdfDiffuse')
    return {
        "input": nMain.inputs['Color'],
        "input2": None,
        "output": nMain.outputs['BSDF'],
        "node": nMain
    }


def makeMcMainDiffuseTranslucent(nodes, links):
    nMain = nodes.new('ShaderNodeBsdfDiffuse')
    nMain.location = (200.0, 00.0)
    nMain2 = nodes.new('ShaderNodeBsdfTranslucent')
    nMain2.location = (200.0, -200.0)
    nMix = nodes.new('ShaderNodeMixShader')
    nMix.inputs[0].default_value = 0

    links.new(nMain.outputs['BSDF'], nMix.inputs[1])
    links.new(nMain2.outputs['BSDF'], nMix.inputs[2])

    return {
        "input": nMain.inputs['Color'],
        "input2": nMain2.inputs['Color'],
        "output": nMix.outputs['Shader'],
        "node": nMix
    }


def makeMcMainTranslucent(nodes, links):
    nMain = nodes.new('ShaderNodeBsdfTranslucent')
    return {
        "input": nMain.inputs['Color'],
        "input2": None,
        "output": nMain.outputs['BSDF'],
        "node": nMain
    }


def makeMcMainInvisible(nodes, links):
    nMain = nodes.new('ShaderNodeBsdfTransparent')
    return {
        "input": nMain.inputs['Color'],
        "input2": None,
        "output": nMain.outputs['BSDF'],
        "node": nMain
    }


def makeMcMainGlass(nodes, links):
    nMain = nodes.new('ShaderNodeBsdfGlass')
    return {
        "input": nMain.inputs['Color'],
        "input2": None,
        "output": nMain.outputs['BSDF'],
        "node": nMain
    }


def makeMcMainGlossy(nodes, links):
    nMain = nodes.new('ShaderNodeBsdfGlossy')
    nMain.distribution = 'BECKMANN';
    nMain.inputs[1].default_value = 0.25

    return {
        "input": nMain.inputs['Color'],
        "input2": None,
        "output": nMain.outputs['BSDF'],
        "node": nMain
    }


def armor_enchanted(myNodes, myLinks):
    print("ENCHANTED")
    myNodes.clear()
    from collections import namedtuple
    MyStruct = namedtuple('MyStruct', 'nodes links')
    group = MyStruct(nodes=myNodes, links=myLinks)

    nodes = []
    nodes.append(group.nodes.new('ShaderNodeTexNoise'))
    nodes.append(group.nodes.new('ShaderNodeBrightContrast'))
    nodes.append(group.nodes.new('ShaderNodeNewGeometry'))
    nodes.append(group.nodes.new('ShaderNodeBsdfGlossy'))
    nodes.append(group.nodes.new('ShaderNodeRGB'))
    nodes.append(group.nodes.new('ShaderNodeMixShader'))
    nodes.append(group.nodes.new('ShaderNodeOutputMaterial'))
    nodes.append(group.nodes.new('ShaderNodeMixShader'))
    nodes.append(group.nodes.new('ShaderNodeLightPath'))
    nodes.append(group.nodes.new('ShaderNodeBsdfTransparent'))
    nodes.append(group.nodes.new('ShaderNodeNewGeometry'))
    nodes.append(group.nodes.new('ShaderNodeMixShader'))
    nodes.append(group.nodes.new('ShaderNodeMixShader'))
    nodes.append(group.nodes.new('ShaderNodeBsdfTransparent'))
    nodes.append(group.nodes.new('ShaderNodeMixShader'))
    nodes.append(group.nodes.new('ShaderNodeEmission'))
    group.links.new(group.nodes[0].outputs[1], group.nodes[1].inputs[0], False)
    group.links.new(group.nodes[2].outputs[0], group.nodes[0].inputs[0], False)
    group.links.new(group.nodes[4].outputs[0], group.nodes[3].inputs[0], False)
    group.links.new(group.nodes[3].outputs[0], group.nodes[5].inputs[1], False)
    group.links.new(group.nodes[1].outputs[0], group.nodes[5].inputs[0], False)
    group.links.new(group.nodes[13].outputs[0], group.nodes[14].inputs[2], False)
    group.links.new(group.nodes[13].outputs[0], group.nodes[7].inputs[1], False)
    group.links.new(group.nodes[7].outputs[0], group.nodes[14].inputs[1], False)
    group.links.new(group.nodes[9].outputs[0], group.nodes[5].inputs[2], False)
    group.links.new(group.nodes[10].outputs[6], group.nodes[11].inputs[0], False)
    group.links.new(group.nodes[8].outputs[9], group.nodes[12].inputs[0], False)
    group.links.new(group.nodes[8].outputs[0], group.nodes[7].inputs[0], False)
    group.links.new(group.nodes[9].outputs[0], group.nodes[11].inputs[2], False)
    group.links.new(group.nodes[9].outputs[0], group.nodes[12].inputs[2], False)
    group.links.new(group.nodes[11].outputs[0], group.nodes[12].inputs[1], False)
    group.links.new(group.nodes[5].outputs[0], group.nodes[11].inputs[1], False)
    group.links.new(group.nodes[12].outputs[0], group.nodes[7].inputs[2], False)
    group.links.new(group.nodes[14].outputs[0], group.nodes[6].inputs[0], False)
    group.links.new(group.nodes[15].outputs[0], group.nodes[6].inputs[1], False)
    setattr(nodes[0], 'bl_description', '')
    setattr(nodes[0], 'bl_height_default', 100.0)
    setattr(nodes[0], 'bl_height_max', 30.0)
    setattr(nodes[0], 'bl_height_min', 30.0)
    setattr(nodes[0], 'bl_icon', 'NONE')
    setattr(nodes[0], 'bl_idname', 'ShaderNodeTexNoise')
    setattr(nodes[0], 'bl_label', 'Noise Texture')
    setattr(nodes[0], 'bl_static_type', 'TEX_NOISE')
    setattr(nodes[0], 'bl_width_default', 140.0)
    setattr(nodes[0], 'bl_width_max', 320.0)
    setattr(nodes[0], 'bl_width_min', 100.0)
    setattr(nodes[0], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[0], 'height', 100.0)
    setattr(nodes[0], 'hide', False)
    setattr(nodes[0], 'label', '')
    setattr(nodes[0], 'location', [-706.3978271484375, 188.09164428710938])
    setattr(nodes[0], 'mute', False)
    setattr(nodes[0], 'name', 'Noise Texture')
    setattr(nodes[0], 'parent', None)
    setattr(nodes[0], 'select', True)
    setattr(nodes[0], 'show_options', True)
    setattr(nodes[0], 'show_preview', False)
    setattr(nodes[0], 'show_texture', False)
    setattr(nodes[0], 'use_custom_color', False)
    setattr(nodes[0], 'width', 140.0)
    setattr(nodes[0], 'width_hidden', 42.0)
    setattr(nodes[0].inputs[0], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[0].inputs[0], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[0].inputs[0], 'enabled', True)
    setattr(nodes[0].inputs[0], 'hide', False)
    setattr(nodes[0].inputs[0], 'hide_value', True)
    setattr(nodes[0].inputs[0], 'link_limit', 1)
    setattr(nodes[0].inputs[0], 'name', 'Vector')
    setattr(nodes[0].inputs[0], 'show_expanded', False)
    setattr(nodes[0].inputs[0], 'type', 'VECTOR')
    setattr(nodes[0].inputs[1], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[0].inputs[1], 'default_value', 3.0)
    setattr(nodes[0].inputs[1], 'enabled', True)
    setattr(nodes[0].inputs[1], 'hide', False)
    setattr(nodes[0].inputs[1], 'hide_value', False)
    setattr(nodes[0].inputs[1], 'link_limit', 1)
    setattr(nodes[0].inputs[1], 'name', 'Scale')
    setattr(nodes[0].inputs[1], 'show_expanded', False)
    setattr(nodes[0].inputs[1], 'type', 'VALUE')
    setattr(nodes[0].inputs[2], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[0].inputs[2], 'default_value', 0.5)
    setattr(nodes[0].inputs[2], 'enabled', True)
    setattr(nodes[0].inputs[2], 'hide', False)
    setattr(nodes[0].inputs[2], 'hide_value', False)
    setattr(nodes[0].inputs[2], 'link_limit', 1)
    setattr(nodes[0].inputs[2], 'name', 'Detail')
    setattr(nodes[0].inputs[2], 'show_expanded', False)
    setattr(nodes[0].inputs[2], 'type', 'VALUE')
    setattr(nodes[0].inputs[3], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[0].inputs[3], 'default_value', 0.0)
    setattr(nodes[0].inputs[3], 'enabled', True)
    setattr(nodes[0].inputs[3], 'hide', False)
    setattr(nodes[0].inputs[3], 'hide_value', False)
    setattr(nodes[0].inputs[3], 'link_limit', 1)
    setattr(nodes[0].inputs[3], 'name', 'Distortion')
    setattr(nodes[0].inputs[3], 'show_expanded', False)
    setattr(nodes[0].inputs[3], 'type', 'VALUE')
    setattr(nodes[0].outputs[0], 'bl_idname', 'NodeSocketColor')
    setattr(nodes[0].outputs[0], 'default_value', [0.0, 0.0, 0.0, 0.0])
    setattr(nodes[0].outputs[0], 'enabled', True)
    setattr(nodes[0].outputs[0], 'hide', False)
    setattr(nodes[0].outputs[0], 'hide_value', False)
    setattr(nodes[0].outputs[0], 'link_limit', 4095)
    setattr(nodes[0].outputs[0], 'name', 'Color')
    setattr(nodes[0].outputs[0], 'show_expanded', False)
    setattr(nodes[0].outputs[0], 'type', 'RGBA')
    setattr(nodes[0].outputs[1], 'bl_idname', 'NodeSocketFloatFactor')
    setattr(nodes[0].outputs[1], 'default_value', 0.0)
    setattr(nodes[0].outputs[1], 'enabled', True)
    setattr(nodes[0].outputs[1], 'hide', False)
    setattr(nodes[0].outputs[1], 'hide_value', False)
    setattr(nodes[0].outputs[1], 'link_limit', 4095)
    setattr(nodes[0].outputs[1], 'name', 'Fac')
    setattr(nodes[0].outputs[1], 'show_expanded', False)
    setattr(nodes[0].outputs[1], 'type', 'VALUE')
    setattr(nodes[1], 'bl_description', '')
    setattr(nodes[1], 'bl_height_default', 100.0)
    setattr(nodes[1], 'bl_height_max', 30.0)
    setattr(nodes[1], 'bl_height_min', 30.0)
    setattr(nodes[1], 'bl_icon', 'NONE')
    setattr(nodes[1], 'bl_idname', 'ShaderNodeBrightContrast')
    setattr(nodes[1], 'bl_label', 'Bright/Contrast')
    setattr(nodes[1], 'bl_static_type', 'BRIGHTCONTRAST')
    setattr(nodes[1], 'bl_width_default', 140.0)
    setattr(nodes[1], 'bl_width_max', 320.0)
    setattr(nodes[1], 'bl_width_min', 100.0)
    setattr(nodes[1], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[1], 'height', 100.0)
    setattr(nodes[1], 'hide', False)
    setattr(nodes[1], 'label', '')
    setattr(nodes[1], 'location', [-522.6414794921875, 152.049072265625])
    setattr(nodes[1], 'mute', False)
    setattr(nodes[1], 'name', 'Bright/Contrast')
    setattr(nodes[1], 'parent', None)
    setattr(nodes[1], 'select', True)
    setattr(nodes[1], 'show_options', True)
    setattr(nodes[1], 'show_preview', False)
    setattr(nodes[1], 'show_texture', False)
    setattr(nodes[1], 'use_custom_color', False)
    setattr(nodes[1], 'width', 140.0)
    setattr(nodes[1], 'width_hidden', 42.0)
    setattr(nodes[1].inputs[0], 'bl_idname', 'NodeSocketColor')
    setattr(nodes[1].inputs[0], 'default_value', [1.0, 1.0, 1.0, 1.0])
    setattr(nodes[1].inputs[0], 'enabled', True)
    setattr(nodes[1].inputs[0], 'hide', False)
    setattr(nodes[1].inputs[0], 'hide_value', False)
    setattr(nodes[1].inputs[0], 'link_limit', 1)
    setattr(nodes[1].inputs[0], 'name', 'Color')
    setattr(nodes[1].inputs[0], 'show_expanded', False)
    setattr(nodes[1].inputs[0], 'type', 'RGBA')
    setattr(nodes[1].inputs[1], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[1].inputs[1], 'default_value', 0.04999998211860657)
    setattr(nodes[1].inputs[1], 'enabled', True)
    setattr(nodes[1].inputs[1], 'hide', False)
    setattr(nodes[1].inputs[1], 'hide_value', False)
    setattr(nodes[1].inputs[1], 'link_limit', 1)
    setattr(nodes[1].inputs[1], 'name', 'Bright')
    setattr(nodes[1].inputs[1], 'show_expanded', False)
    setattr(nodes[1].inputs[1], 'type', 'VALUE')
    setattr(nodes[1].inputs[2], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[1].inputs[2], 'default_value', 2.8000001907348633)
    setattr(nodes[1].inputs[2], 'enabled', True)
    setattr(nodes[1].inputs[2], 'hide', False)
    setattr(nodes[1].inputs[2], 'hide_value', False)
    setattr(nodes[1].inputs[2], 'link_limit', 1)
    setattr(nodes[1].inputs[2], 'name', 'Contrast')
    setattr(nodes[1].inputs[2], 'show_expanded', False)
    setattr(nodes[1].inputs[2], 'type', 'VALUE')
    setattr(nodes[1].outputs[0], 'bl_idname', 'NodeSocketColor')
    setattr(nodes[1].outputs[0], 'default_value', [0.0, 0.0, 0.0, 0.0])
    setattr(nodes[1].outputs[0], 'enabled', True)
    setattr(nodes[1].outputs[0], 'hide', False)
    setattr(nodes[1].outputs[0], 'hide_value', False)
    setattr(nodes[1].outputs[0], 'link_limit', 4095)
    setattr(nodes[1].outputs[0], 'name', 'Color')
    setattr(nodes[1].outputs[0], 'show_expanded', False)
    setattr(nodes[1].outputs[0], 'type', 'RGBA')
    setattr(nodes[2], 'bl_description', '')
    setattr(nodes[2], 'bl_height_default', 100.0)
    setattr(nodes[2], 'bl_height_max', 30.0)
    setattr(nodes[2], 'bl_height_min', 30.0)
    setattr(nodes[2], 'bl_icon', 'NONE')
    setattr(nodes[2], 'bl_idname', 'ShaderNodeNewGeometry')
    setattr(nodes[2], 'bl_label', 'Geometry')
    setattr(nodes[2], 'bl_static_type', 'NEW_GEOMETRY')
    setattr(nodes[2], 'bl_width_default', 140.0)
    setattr(nodes[2], 'bl_width_max', 320.0)
    setattr(nodes[2], 'bl_width_min', 100.0)
    setattr(nodes[2], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[2], 'height', 100.0)
    setattr(nodes[2], 'hide', False)
    setattr(nodes[2], 'label', '')
    setattr(nodes[2], 'location', [-890.8740844726562, 231.52224731445312])
    setattr(nodes[2], 'mute', False)
    setattr(nodes[2], 'name', 'Geometry.001')
    setattr(nodes[2], 'parent', None)
    setattr(nodes[2], 'select', True)
    setattr(nodes[2], 'show_options', True)
    setattr(nodes[2], 'show_preview', False)
    setattr(nodes[2], 'show_texture', False)
    setattr(nodes[2], 'use_custom_color', False)
    setattr(nodes[2], 'width', 140.0)
    setattr(nodes[2], 'width_hidden', 42.0)
    setattr(nodes[2].outputs[0], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[2].outputs[0], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[2].outputs[0], 'enabled', True)
    setattr(nodes[2].outputs[0], 'hide', False)
    setattr(nodes[2].outputs[0], 'hide_value', False)
    setattr(nodes[2].outputs[0], 'link_limit', 4095)
    setattr(nodes[2].outputs[0], 'name', 'Position')
    setattr(nodes[2].outputs[0], 'show_expanded', False)
    setattr(nodes[2].outputs[0], 'type', 'VECTOR')
    setattr(nodes[2].outputs[1], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[2].outputs[1], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[2].outputs[1], 'enabled', True)
    setattr(nodes[2].outputs[1], 'hide', False)
    setattr(nodes[2].outputs[1], 'hide_value', False)
    setattr(nodes[2].outputs[1], 'link_limit', 4095)
    setattr(nodes[2].outputs[1], 'name', 'Normal')
    setattr(nodes[2].outputs[1], 'show_expanded', False)
    setattr(nodes[2].outputs[1], 'type', 'VECTOR')
    setattr(nodes[2].outputs[2], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[2].outputs[2], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[2].outputs[2], 'enabled', True)
    setattr(nodes[2].outputs[2], 'hide', False)
    setattr(nodes[2].outputs[2], 'hide_value', False)
    setattr(nodes[2].outputs[2], 'link_limit', 4095)
    setattr(nodes[2].outputs[2], 'name', 'Tangent')
    setattr(nodes[2].outputs[2], 'show_expanded', False)
    setattr(nodes[2].outputs[2], 'type', 'VECTOR')
    setattr(nodes[2].outputs[3], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[2].outputs[3], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[2].outputs[3], 'enabled', True)
    setattr(nodes[2].outputs[3], 'hide', False)
    setattr(nodes[2].outputs[3], 'hide_value', False)
    setattr(nodes[2].outputs[3], 'link_limit', 4095)
    setattr(nodes[2].outputs[3], 'name', 'True Normal')
    setattr(nodes[2].outputs[3], 'show_expanded', False)
    setattr(nodes[2].outputs[3], 'type', 'VECTOR')
    setattr(nodes[2].outputs[4], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[2].outputs[4], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[2].outputs[4], 'enabled', True)
    setattr(nodes[2].outputs[4], 'hide', False)
    setattr(nodes[2].outputs[4], 'hide_value', False)
    setattr(nodes[2].outputs[4], 'link_limit', 4095)
    setattr(nodes[2].outputs[4], 'name', 'Incoming')
    setattr(nodes[2].outputs[4], 'show_expanded', False)
    setattr(nodes[2].outputs[4], 'type', 'VECTOR')
    setattr(nodes[2].outputs[5], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[2].outputs[5], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[2].outputs[5], 'enabled', True)
    setattr(nodes[2].outputs[5], 'hide', False)
    setattr(nodes[2].outputs[5], 'hide_value', False)
    setattr(nodes[2].outputs[5], 'link_limit', 4095)
    setattr(nodes[2].outputs[5], 'name', 'Parametric')
    setattr(nodes[2].outputs[5], 'show_expanded', False)
    setattr(nodes[2].outputs[5], 'type', 'VECTOR')
    setattr(nodes[2].outputs[6], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[2].outputs[6], 'default_value', 0.0)
    setattr(nodes[2].outputs[6], 'enabled', True)
    setattr(nodes[2].outputs[6], 'hide', False)
    setattr(nodes[2].outputs[6], 'hide_value', False)
    setattr(nodes[2].outputs[6], 'link_limit', 4095)
    setattr(nodes[2].outputs[6], 'name', 'Backfacing')
    setattr(nodes[2].outputs[6], 'show_expanded', False)
    setattr(nodes[2].outputs[6], 'type', 'VALUE')
    setattr(nodes[2].outputs[7], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[2].outputs[7], 'default_value', 0.0)
    setattr(nodes[2].outputs[7], 'enabled', True)
    setattr(nodes[2].outputs[7], 'hide', False)
    setattr(nodes[2].outputs[7], 'hide_value', False)
    setattr(nodes[2].outputs[7], 'link_limit', 4095)
    setattr(nodes[2].outputs[7], 'name', 'Pointiness')
    setattr(nodes[2].outputs[7], 'show_expanded', False)
    setattr(nodes[2].outputs[7], 'type', 'VALUE')
    setattr(nodes[3], 'bl_description', '')
    setattr(nodes[3], 'bl_height_default', 100.0)
    setattr(nodes[3], 'bl_height_max', 30.0)
    setattr(nodes[3], 'bl_height_min', 30.0)
    setattr(nodes[3], 'bl_icon', 'NONE')
    setattr(nodes[3], 'bl_idname', 'ShaderNodeBsdfGlossy')
    setattr(nodes[3], 'bl_label', 'Glossy BSDF')
    setattr(nodes[3], 'bl_static_type', 'BSDF_GLOSSY')
    setattr(nodes[3], 'bl_width_default', 150.0)
    setattr(nodes[3], 'bl_width_max', 320.0)
    setattr(nodes[3], 'bl_width_min', 120.0)
    setattr(nodes[3], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[3], 'distribution', 'GGX')
    setattr(nodes[3], 'height', 100.0)
    setattr(nodes[3], 'hide', False)
    setattr(nodes[3], 'label', '')
    setattr(nodes[3], 'location', [-900.2193603515625, 7.46881103515625])
    setattr(nodes[3], 'mute', False)
    setattr(nodes[3], 'name', 'Glossy BSDF')
    setattr(nodes[3], 'parent', None)
    setattr(nodes[3], 'select', True)
    setattr(nodes[3], 'show_options', True)
    setattr(nodes[3], 'show_preview', False)
    setattr(nodes[3], 'show_texture', False)
    setattr(nodes[3], 'use_custom_color', False)
    setattr(nodes[3], 'width', 150.0)
    setattr(nodes[3], 'width_hidden', 42.0)
    setattr(nodes[3].inputs[0], 'bl_idname', 'NodeSocketColor')
    setattr(nodes[3].inputs[0], 'default_value', [0.800000011920929, 0.800000011920929, 0.800000011920929, 1.0])
    setattr(nodes[3].inputs[0], 'enabled', True)
    setattr(nodes[3].inputs[0], 'hide', False)
    setattr(nodes[3].inputs[0], 'hide_value', False)
    setattr(nodes[3].inputs[0], 'link_limit', 1)
    setattr(nodes[3].inputs[0], 'name', 'Color')
    setattr(nodes[3].inputs[0], 'show_expanded', False)
    setattr(nodes[3].inputs[0], 'type', 'RGBA')
    setattr(nodes[3].inputs[1], 'bl_idname', 'NodeSocketFloatFactor')
    setattr(nodes[3].inputs[1], 'default_value', 0.20000000298023224)
    setattr(nodes[3].inputs[1], 'enabled', True)
    setattr(nodes[3].inputs[1], 'hide', False)
    setattr(nodes[3].inputs[1], 'hide_value', False)
    setattr(nodes[3].inputs[1], 'link_limit', 1)
    setattr(nodes[3].inputs[1], 'name', 'Roughness')
    setattr(nodes[3].inputs[1], 'show_expanded', False)
    setattr(nodes[3].inputs[1], 'type', 'VALUE')
    setattr(nodes[3].inputs[2], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[3].inputs[2], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[3].inputs[2], 'enabled', True)
    setattr(nodes[3].inputs[2], 'hide', False)
    setattr(nodes[3].inputs[2], 'hide_value', True)
    setattr(nodes[3].inputs[2], 'link_limit', 1)
    setattr(nodes[3].inputs[2], 'name', 'Normal')
    setattr(nodes[3].inputs[2], 'show_expanded', False)
    setattr(nodes[3].inputs[2], 'type', 'VECTOR')
    setattr(nodes[3].outputs[0], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[3].outputs[0], 'enabled', True)
    setattr(nodes[3].outputs[0], 'hide', False)
    setattr(nodes[3].outputs[0], 'hide_value', False)
    setattr(nodes[3].outputs[0], 'link_limit', 4095)
    setattr(nodes[3].outputs[0], 'name', 'BSDF')
    setattr(nodes[3].outputs[0], 'show_expanded', False)
    setattr(nodes[3].outputs[0], 'type', 'SHADER')
    setattr(nodes[4], 'bl_description', '')
    setattr(nodes[4], 'bl_height_default', 100.0)
    setattr(nodes[4], 'bl_height_max', 30.0)
    setattr(nodes[4], 'bl_height_min', 30.0)
    setattr(nodes[4], 'bl_icon', 'NONE')
    setattr(nodes[4], 'bl_idname', 'ShaderNodeRGB')
    setattr(nodes[4], 'bl_label', 'RGB')
    setattr(nodes[4], 'bl_static_type', 'RGB')
    setattr(nodes[4], 'bl_width_default', 140.0)
    setattr(nodes[4], 'bl_width_max', 320.0)
    setattr(nodes[4], 'bl_width_min', 100.0)
    setattr(nodes[4], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[4], 'height', 100.0)
    setattr(nodes[4], 'hide', False)
    setattr(nodes[4], 'label', '')
    setattr(nodes[4], 'location', [-1119.9010009765625, -84.7864761352539])
    setattr(nodes[4], 'mute', False)
    setattr(nodes[4], 'name', 'RGB')
    setattr(nodes[4], 'parent', None)
    setattr(nodes[4], 'select', True)
    setattr(nodes[4], 'show_options', True)
    setattr(nodes[4], 'show_preview', False)
    setattr(nodes[4], 'show_texture', False)
    setattr(nodes[4], 'use_custom_color', False)
    setattr(nodes[4], 'width', 140.0)
    setattr(nodes[4], 'width_hidden', 42.0)
    setattr(nodes[4].outputs[0], 'bl_idname', 'NodeSocketColor')
    setattr(nodes[4].outputs[0], 'default_value', [0.6559306979179382, 0.1212848573923111, 0.6384621262550354, 1.0])
    setattr(nodes[4].outputs[0], 'enabled', True)
    setattr(nodes[4].outputs[0], 'hide', False)
    setattr(nodes[4].outputs[0], 'hide_value', False)
    setattr(nodes[4].outputs[0], 'link_limit', 4095)
    setattr(nodes[4].outputs[0], 'name', 'Color')
    setattr(nodes[4].outputs[0], 'show_expanded', False)
    setattr(nodes[4].outputs[0], 'type', 'RGBA')
    setattr(nodes[5], 'bl_description', '')
    setattr(nodes[5], 'bl_height_default', 100.0)
    setattr(nodes[5], 'bl_height_max', 30.0)
    setattr(nodes[5], 'bl_height_min', 30.0)
    setattr(nodes[5], 'bl_icon', 'NONE')
    setattr(nodes[5], 'bl_idname', 'ShaderNodeMixShader')
    setattr(nodes[5], 'bl_label', 'Mix Shader')
    setattr(nodes[5], 'bl_static_type', 'MIX_SHADER')
    setattr(nodes[5], 'bl_width_default', 140.0)
    setattr(nodes[5], 'bl_width_max', 320.0)
    setattr(nodes[5], 'bl_width_min', 100.0)
    setattr(nodes[5], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[5], 'height', 100.0)
    setattr(nodes[5], 'hide', False)
    setattr(nodes[5], 'label', '')
    setattr(nodes[5], 'location', [-341.47576904296875, 2.2539520263671875])
    setattr(nodes[5], 'mute', False)
    setattr(nodes[5], 'name', 'Mix Shader.001')
    setattr(nodes[5], 'parent', None)
    setattr(nodes[5], 'select', True)
    setattr(nodes[5], 'show_options', True)
    setattr(nodes[5], 'show_preview', False)
    setattr(nodes[5], 'show_texture', False)
    setattr(nodes[5], 'use_custom_color', False)
    setattr(nodes[5], 'width', 140.0)
    setattr(nodes[5], 'width_hidden', 42.0)
    setattr(nodes[5].inputs[0], 'bl_idname', 'NodeSocketFloatFactor')
    setattr(nodes[5].inputs[0], 'default_value', 0.8500000238418579)
    setattr(nodes[5].inputs[0], 'enabled', True)
    setattr(nodes[5].inputs[0], 'hide', False)
    setattr(nodes[5].inputs[0], 'hide_value', False)
    setattr(nodes[5].inputs[0], 'link_limit', 1)
    setattr(nodes[5].inputs[0], 'name', 'Fac')
    setattr(nodes[5].inputs[0], 'show_expanded', False)
    setattr(nodes[5].inputs[0], 'type', 'VALUE')
    setattr(nodes[5].inputs[1], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[5].inputs[1], 'enabled', True)
    setattr(nodes[5].inputs[1], 'hide', False)
    setattr(nodes[5].inputs[1], 'hide_value', False)
    setattr(nodes[5].inputs[1], 'link_limit', 1)
    setattr(nodes[5].inputs[1], 'name', 'Shader')
    setattr(nodes[5].inputs[1], 'show_expanded', False)
    setattr(nodes[5].inputs[1], 'type', 'SHADER')
    setattr(nodes[5].inputs[2], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[5].inputs[2], 'enabled', True)
    setattr(nodes[5].inputs[2], 'hide', False)
    setattr(nodes[5].inputs[2], 'hide_value', False)
    setattr(nodes[5].inputs[2], 'link_limit', 1)
    setattr(nodes[5].inputs[2], 'name', 'Shader')
    setattr(nodes[5].inputs[2], 'show_expanded', False)
    setattr(nodes[5].inputs[2], 'type', 'SHADER')
    setattr(nodes[5].outputs[0], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[5].outputs[0], 'enabled', True)
    setattr(nodes[5].outputs[0], 'hide', False)
    setattr(nodes[5].outputs[0], 'hide_value', False)
    setattr(nodes[5].outputs[0], 'link_limit', 4095)
    setattr(nodes[5].outputs[0], 'name', 'Shader')
    setattr(nodes[5].outputs[0], 'show_expanded', False)
    setattr(nodes[5].outputs[0], 'type', 'SHADER')
    setattr(nodes[6], 'bl_description', '')
    setattr(nodes[6], 'bl_height_default', 100.0)
    setattr(nodes[6], 'bl_height_max', 30.0)
    setattr(nodes[6], 'bl_height_min', 30.0)
    setattr(nodes[6], 'bl_icon', 'NONE')
    setattr(nodes[6], 'bl_idname', 'ShaderNodeOutputMaterial')
    setattr(nodes[6], 'bl_label', 'Material Output')
    setattr(nodes[6], 'bl_static_type', 'OUTPUT_MATERIAL')
    setattr(nodes[6], 'bl_width_default', 140.0)
    setattr(nodes[6], 'bl_width_max', 320.0)
    setattr(nodes[6], 'bl_width_min', 100.0)
    setattr(nodes[6], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[6], 'height', 100.0)
    setattr(nodes[6], 'hide', False)
    setattr(nodes[6], 'is_active_output', True)
    setattr(nodes[6], 'label', '')
    setattr(nodes[6], 'location', [1119.90087890625, 52.667572021484375])
    setattr(nodes[6], 'mute', False)
    setattr(nodes[6], 'name', 'Material Output')
    setattr(nodes[6], 'parent', None)
    setattr(nodes[6], 'select', True)
    setattr(nodes[6], 'show_options', True)
    setattr(nodes[6], 'show_preview', False)
    setattr(nodes[6], 'show_texture', False)
    setattr(nodes[6], 'use_custom_color', False)
    setattr(nodes[6], 'width', 140.0)
    setattr(nodes[6], 'width_hidden', 42.0)
    setattr(nodes[6].inputs[0], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[6].inputs[0], 'enabled', True)
    setattr(nodes[6].inputs[0], 'hide', False)
    setattr(nodes[6].inputs[0], 'hide_value', False)
    setattr(nodes[6].inputs[0], 'link_limit', 1)
    setattr(nodes[6].inputs[0], 'name', 'Surface')
    setattr(nodes[6].inputs[0], 'show_expanded', False)
    setattr(nodes[6].inputs[0], 'type', 'SHADER')
    setattr(nodes[6].inputs[1], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[6].inputs[1], 'enabled', True)
    setattr(nodes[6].inputs[1], 'hide', False)
    setattr(nodes[6].inputs[1], 'hide_value', False)
    setattr(nodes[6].inputs[1], 'link_limit', 1)
    setattr(nodes[6].inputs[1], 'name', 'Volume')
    setattr(nodes[6].inputs[1], 'show_expanded', False)
    setattr(nodes[6].inputs[1], 'type', 'SHADER')
    setattr(nodes[6].inputs[2], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[6].inputs[2], 'default_value', 0.0)
    setattr(nodes[6].inputs[2], 'enabled', True)
    setattr(nodes[6].inputs[2], 'hide', False)
    setattr(nodes[6].inputs[2], 'hide_value', True)
    setattr(nodes[6].inputs[2], 'link_limit', 1)
    setattr(nodes[6].inputs[2], 'name', 'Displacement')
    setattr(nodes[6].inputs[2], 'show_expanded', False)
    setattr(nodes[6].inputs[2], 'type', 'VALUE')
    setattr(nodes[7], 'bl_description', '')
    setattr(nodes[7], 'bl_height_default', 100.0)
    setattr(nodes[7], 'bl_height_max', 30.0)
    setattr(nodes[7], 'bl_height_min', 30.0)
    setattr(nodes[7], 'bl_icon', 'NONE')
    setattr(nodes[7], 'bl_idname', 'ShaderNodeMixShader')
    setattr(nodes[7], 'bl_label', 'Mix Shader')
    setattr(nodes[7], 'bl_static_type', 'MIX_SHADER')
    setattr(nodes[7], 'bl_width_default', 140.0)
    setattr(nodes[7], 'bl_width_max', 320.0)
    setattr(nodes[7], 'bl_width_min', 100.0)
    setattr(nodes[7], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[7], 'height', 100.0)
    setattr(nodes[7], 'hide', False)
    setattr(nodes[7], 'label', '')
    setattr(nodes[7], 'location', [623.2561645507812, 61.183441162109375])
    setattr(nodes[7], 'mute', False)
    setattr(nodes[7], 'name', 'Mix Shader')
    setattr(nodes[7], 'parent', None)
    setattr(nodes[7], 'select', True)
    setattr(nodes[7], 'show_options', True)
    setattr(nodes[7], 'show_preview', False)
    setattr(nodes[7], 'show_texture', False)
    setattr(nodes[7], 'use_custom_color', False)
    setattr(nodes[7], 'width', 140.0)
    setattr(nodes[7], 'width_hidden', 42.0)
    setattr(nodes[7].inputs[0], 'bl_idname', 'NodeSocketFloatFactor')
    setattr(nodes[7].inputs[0], 'default_value', 0.5)
    setattr(nodes[7].inputs[0], 'enabled', True)
    setattr(nodes[7].inputs[0], 'hide', False)
    setattr(nodes[7].inputs[0], 'hide_value', False)
    setattr(nodes[7].inputs[0], 'link_limit', 1)
    setattr(nodes[7].inputs[0], 'name', 'Fac')
    setattr(nodes[7].inputs[0], 'show_expanded', False)
    setattr(nodes[7].inputs[0], 'type', 'VALUE')
    setattr(nodes[7].inputs[1], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[7].inputs[1], 'enabled', True)
    setattr(nodes[7].inputs[1], 'hide', False)
    setattr(nodes[7].inputs[1], 'hide_value', False)
    setattr(nodes[7].inputs[1], 'link_limit', 1)
    setattr(nodes[7].inputs[1], 'name', 'Shader')
    setattr(nodes[7].inputs[1], 'show_expanded', False)
    setattr(nodes[7].inputs[1], 'type', 'SHADER')
    setattr(nodes[7].inputs[2], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[7].inputs[2], 'enabled', True)
    setattr(nodes[7].inputs[2], 'hide', False)
    setattr(nodes[7].inputs[2], 'hide_value', False)
    setattr(nodes[7].inputs[2], 'link_limit', 1)
    setattr(nodes[7].inputs[2], 'name', 'Shader')
    setattr(nodes[7].inputs[2], 'show_expanded', False)
    setattr(nodes[7].inputs[2], 'type', 'SHADER')
    setattr(nodes[7].outputs[0], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[7].outputs[0], 'enabled', True)
    setattr(nodes[7].outputs[0], 'hide', False)
    setattr(nodes[7].outputs[0], 'hide_value', False)
    setattr(nodes[7].outputs[0], 'link_limit', 4095)
    setattr(nodes[7].outputs[0], 'name', 'Shader')
    setattr(nodes[7].outputs[0], 'show_expanded', False)
    setattr(nodes[7].outputs[0], 'type', 'SHADER')
    setattr(nodes[8], 'bl_description', '')
    setattr(nodes[8], 'bl_height_default', 100.0)
    setattr(nodes[8], 'bl_height_max', 30.0)
    setattr(nodes[8], 'bl_height_min', 30.0)
    setattr(nodes[8], 'bl_icon', 'NONE')
    setattr(nodes[8], 'bl_idname', 'ShaderNodeLightPath')
    setattr(nodes[8], 'bl_label', 'Light Path')
    setattr(nodes[8], 'bl_static_type', 'LIGHT_PATH')
    setattr(nodes[8], 'bl_width_default', 140.0)
    setattr(nodes[8], 'bl_width_max', 320.0)
    setattr(nodes[8], 'bl_width_min', 100.0)
    setattr(nodes[8], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[8], 'height', 100.0)
    setattr(nodes[8], 'hide', False)
    setattr(nodes[8], 'label', '')
    setattr(nodes[8], 'location', [59.79461669921875, 287.3360595703125])
    setattr(nodes[8], 'mute', False)
    setattr(nodes[8], 'name', 'Light Path')
    setattr(nodes[8], 'parent', None)
    setattr(nodes[8], 'select', True)
    setattr(nodes[8], 'show_options', True)
    setattr(nodes[8], 'show_preview', False)
    setattr(nodes[8], 'show_texture', False)
    setattr(nodes[8], 'use_custom_color', False)
    setattr(nodes[8], 'width', 140.0)
    setattr(nodes[8], 'width_hidden', 42.0)
    setattr(nodes[8].outputs[0], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[8].outputs[0], 'default_value', 0.0)
    setattr(nodes[8].outputs[0], 'enabled', True)
    setattr(nodes[8].outputs[0], 'hide', False)
    setattr(nodes[8].outputs[0], 'hide_value', False)
    setattr(nodes[8].outputs[0], 'link_limit', 4095)
    setattr(nodes[8].outputs[0], 'name', 'Is Camera Ray')
    setattr(nodes[8].outputs[0], 'show_expanded', False)
    setattr(nodes[8].outputs[0], 'type', 'VALUE')
    setattr(nodes[8].outputs[1], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[8].outputs[1], 'default_value', 0.0)
    setattr(nodes[8].outputs[1], 'enabled', True)
    setattr(nodes[8].outputs[1], 'hide', False)
    setattr(nodes[8].outputs[1], 'hide_value', False)
    setattr(nodes[8].outputs[1], 'link_limit', 4095)
    setattr(nodes[8].outputs[1], 'name', 'Is Shadow Ray')
    setattr(nodes[8].outputs[1], 'show_expanded', False)
    setattr(nodes[8].outputs[1], 'type', 'VALUE')
    setattr(nodes[8].outputs[2], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[8].outputs[2], 'default_value', 0.0)
    setattr(nodes[8].outputs[2], 'enabled', True)
    setattr(nodes[8].outputs[2], 'hide', False)
    setattr(nodes[8].outputs[2], 'hide_value', False)
    setattr(nodes[8].outputs[2], 'link_limit', 4095)
    setattr(nodes[8].outputs[2], 'name', 'Is Diffuse Ray')
    setattr(nodes[8].outputs[2], 'show_expanded', False)
    setattr(nodes[8].outputs[2], 'type', 'VALUE')
    setattr(nodes[8].outputs[3], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[8].outputs[3], 'default_value', 0.0)
    setattr(nodes[8].outputs[3], 'enabled', True)
    setattr(nodes[8].outputs[3], 'hide', False)
    setattr(nodes[8].outputs[3], 'hide_value', False)
    setattr(nodes[8].outputs[3], 'link_limit', 4095)
    setattr(nodes[8].outputs[3], 'name', 'Is Glossy Ray')
    setattr(nodes[8].outputs[3], 'show_expanded', False)
    setattr(nodes[8].outputs[3], 'type', 'VALUE')
    setattr(nodes[8].outputs[4], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[8].outputs[4], 'default_value', 0.0)
    setattr(nodes[8].outputs[4], 'enabled', True)
    setattr(nodes[8].outputs[4], 'hide', False)
    setattr(nodes[8].outputs[4], 'hide_value', False)
    setattr(nodes[8].outputs[4], 'link_limit', 4095)
    setattr(nodes[8].outputs[4], 'name', 'Is Singular Ray')
    setattr(nodes[8].outputs[4], 'show_expanded', False)
    setattr(nodes[8].outputs[4], 'type', 'VALUE')
    setattr(nodes[8].outputs[5], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[8].outputs[5], 'default_value', 0.0)
    setattr(nodes[8].outputs[5], 'enabled', True)
    setattr(nodes[8].outputs[5], 'hide', False)
    setattr(nodes[8].outputs[5], 'hide_value', False)
    setattr(nodes[8].outputs[5], 'link_limit', 4095)
    setattr(nodes[8].outputs[5], 'name', 'Is Reflection Ray')
    setattr(nodes[8].outputs[5], 'show_expanded', False)
    setattr(nodes[8].outputs[5], 'type', 'VALUE')
    setattr(nodes[8].outputs[6], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[8].outputs[6], 'default_value', 0.0)
    setattr(nodes[8].outputs[6], 'enabled', True)
    setattr(nodes[8].outputs[6], 'hide', False)
    setattr(nodes[8].outputs[6], 'hide_value', False)
    setattr(nodes[8].outputs[6], 'link_limit', 4095)
    setattr(nodes[8].outputs[6], 'name', 'Is Transmission Ray')
    setattr(nodes[8].outputs[6], 'show_expanded', False)
    setattr(nodes[8].outputs[6], 'type', 'VALUE')
    setattr(nodes[8].outputs[7], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[8].outputs[7], 'default_value', 0.0)
    setattr(nodes[8].outputs[7], 'enabled', True)
    setattr(nodes[8].outputs[7], 'hide', False)
    setattr(nodes[8].outputs[7], 'hide_value', False)
    setattr(nodes[8].outputs[7], 'link_limit', 4095)
    setattr(nodes[8].outputs[7], 'name', 'Ray Length')
    setattr(nodes[8].outputs[7], 'show_expanded', False)
    setattr(nodes[8].outputs[7], 'type', 'VALUE')
    setattr(nodes[8].outputs[8], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[8].outputs[8], 'default_value', 0.0)
    setattr(nodes[8].outputs[8], 'enabled', True)
    setattr(nodes[8].outputs[8], 'hide', False)
    setattr(nodes[8].outputs[8], 'hide_value', False)
    setattr(nodes[8].outputs[8], 'link_limit', 4095)
    setattr(nodes[8].outputs[8], 'name', 'Ray Depth')
    setattr(nodes[8].outputs[8], 'show_expanded', False)
    setattr(nodes[8].outputs[8], 'type', 'VALUE')
    setattr(nodes[8].outputs[9], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[8].outputs[9], 'default_value', 0.0)
    setattr(nodes[8].outputs[9], 'enabled', True)
    setattr(nodes[8].outputs[9], 'hide', False)
    setattr(nodes[8].outputs[9], 'hide_value', False)
    setattr(nodes[8].outputs[9], 'link_limit', 4095)
    setattr(nodes[8].outputs[9], 'name', 'Transparent Depth')
    setattr(nodes[8].outputs[9], 'show_expanded', False)
    setattr(nodes[8].outputs[9], 'type', 'VALUE')
    setattr(nodes[9], 'bl_description', '')
    setattr(nodes[9], 'bl_height_default', 100.0)
    setattr(nodes[9], 'bl_height_max', 30.0)
    setattr(nodes[9], 'bl_height_min', 30.0)
    setattr(nodes[9], 'bl_icon', 'NONE')
    setattr(nodes[9], 'bl_idname', 'ShaderNodeBsdfTransparent')
    setattr(nodes[9], 'bl_label', 'Transparent BSDF')
    setattr(nodes[9], 'bl_static_type', 'BSDF_TRANSPARENT')
    setattr(nodes[9], 'bl_width_default', 140.0)
    setattr(nodes[9], 'bl_width_max', 320.0)
    setattr(nodes[9], 'bl_width_min', 100.0)
    setattr(nodes[9], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[9], 'height', 100.0)
    setattr(nodes[9], 'hide', False)
    setattr(nodes[9], 'label', '')
    setattr(nodes[9], 'location', [-435.41680908203125, -287.3360595703125])
    setattr(nodes[9], 'mute', False)
    setattr(nodes[9], 'name', 'Transparent BSDF.001')
    setattr(nodes[9], 'parent', None)
    setattr(nodes[9], 'select', True)
    setattr(nodes[9], 'show_options', True)
    setattr(nodes[9], 'show_preview', False)
    setattr(nodes[9], 'show_texture', False)
    setattr(nodes[9], 'use_custom_color', False)
    setattr(nodes[9], 'width', 140.0)
    setattr(nodes[9], 'width_hidden', 42.0)
    setattr(nodes[9].inputs[0], 'bl_idname', 'NodeSocketColor')
    setattr(nodes[9].inputs[0], 'default_value', [1.0, 1.0, 1.0, 1.0])
    setattr(nodes[9].inputs[0], 'enabled', True)
    setattr(nodes[9].inputs[0], 'hide', False)
    setattr(nodes[9].inputs[0], 'hide_value', False)
    setattr(nodes[9].inputs[0], 'link_limit', 1)
    setattr(nodes[9].inputs[0], 'name', 'Color')
    setattr(nodes[9].inputs[0], 'show_expanded', False)
    setattr(nodes[9].inputs[0], 'type', 'RGBA')
    setattr(nodes[9].outputs[0], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[9].outputs[0], 'enabled', True)
    setattr(nodes[9].outputs[0], 'hide', False)
    setattr(nodes[9].outputs[0], 'hide_value', False)
    setattr(nodes[9].outputs[0], 'link_limit', 4095)
    setattr(nodes[9].outputs[0], 'name', 'BSDF')
    setattr(nodes[9].outputs[0], 'show_expanded', False)
    setattr(nodes[9].outputs[0], 'type', 'SHADER')
    setattr(nodes[10], 'bl_description', '')
    setattr(nodes[10], 'bl_height_default', 100.0)
    setattr(nodes[10], 'bl_height_max', 30.0)
    setattr(nodes[10], 'bl_height_min', 30.0)
    setattr(nodes[10], 'bl_icon', 'NONE')
    setattr(nodes[10], 'bl_idname', 'ShaderNodeNewGeometry')
    setattr(nodes[10], 'bl_label', 'Geometry')
    setattr(nodes[10], 'bl_static_type', 'NEW_GEOMETRY')
    setattr(nodes[10], 'bl_width_default', 140.0)
    setattr(nodes[10], 'bl_width_max', 320.0)
    setattr(nodes[10], 'bl_width_min', 100.0)
    setattr(nodes[10], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[10], 'height', 100.0)
    setattr(nodes[10], 'hide', False)
    setattr(nodes[10], 'label', '')
    setattr(nodes[10], 'location', [-325.529296875, 263.3585510253906])
    setattr(nodes[10], 'mute', False)
    setattr(nodes[10], 'name', 'Geometry')
    setattr(nodes[10], 'parent', None)
    setattr(nodes[10], 'select', True)
    setattr(nodes[10], 'show_options', True)
    setattr(nodes[10], 'show_preview', False)
    setattr(nodes[10], 'show_texture', False)
    setattr(nodes[10], 'use_custom_color', False)
    setattr(nodes[10], 'width', 140.0)
    setattr(nodes[10], 'width_hidden', 42.0)
    setattr(nodes[10].outputs[0], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[10].outputs[0], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[10].outputs[0], 'enabled', True)
    setattr(nodes[10].outputs[0], 'hide', False)
    setattr(nodes[10].outputs[0], 'hide_value', False)
    setattr(nodes[10].outputs[0], 'link_limit', 4095)
    setattr(nodes[10].outputs[0], 'name', 'Position')
    setattr(nodes[10].outputs[0], 'show_expanded', False)
    setattr(nodes[10].outputs[0], 'type', 'VECTOR')
    setattr(nodes[10].outputs[1], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[10].outputs[1], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[10].outputs[1], 'enabled', True)
    setattr(nodes[10].outputs[1], 'hide', False)
    setattr(nodes[10].outputs[1], 'hide_value', False)
    setattr(nodes[10].outputs[1], 'link_limit', 4095)
    setattr(nodes[10].outputs[1], 'name', 'Normal')
    setattr(nodes[10].outputs[1], 'show_expanded', False)
    setattr(nodes[10].outputs[1], 'type', 'VECTOR')
    setattr(nodes[10].outputs[2], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[10].outputs[2], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[10].outputs[2], 'enabled', True)
    setattr(nodes[10].outputs[2], 'hide', False)
    setattr(nodes[10].outputs[2], 'hide_value', False)
    setattr(nodes[10].outputs[2], 'link_limit', 4095)
    setattr(nodes[10].outputs[2], 'name', 'Tangent')
    setattr(nodes[10].outputs[2], 'show_expanded', False)
    setattr(nodes[10].outputs[2], 'type', 'VECTOR')
    setattr(nodes[10].outputs[3], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[10].outputs[3], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[10].outputs[3], 'enabled', True)
    setattr(nodes[10].outputs[3], 'hide', False)
    setattr(nodes[10].outputs[3], 'hide_value', False)
    setattr(nodes[10].outputs[3], 'link_limit', 4095)
    setattr(nodes[10].outputs[3], 'name', 'True Normal')
    setattr(nodes[10].outputs[3], 'show_expanded', False)
    setattr(nodes[10].outputs[3], 'type', 'VECTOR')
    setattr(nodes[10].outputs[4], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[10].outputs[4], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[10].outputs[4], 'enabled', True)
    setattr(nodes[10].outputs[4], 'hide', False)
    setattr(nodes[10].outputs[4], 'hide_value', False)
    setattr(nodes[10].outputs[4], 'link_limit', 4095)
    setattr(nodes[10].outputs[4], 'name', 'Incoming')
    setattr(nodes[10].outputs[4], 'show_expanded', False)
    setattr(nodes[10].outputs[4], 'type', 'VECTOR')
    setattr(nodes[10].outputs[5], 'bl_idname', 'NodeSocketVector')
    setattr(nodes[10].outputs[5], 'default_value', [0.0, 0.0, 0.0])
    setattr(nodes[10].outputs[5], 'enabled', True)
    setattr(nodes[10].outputs[5], 'hide', False)
    setattr(nodes[10].outputs[5], 'hide_value', False)
    setattr(nodes[10].outputs[5], 'link_limit', 4095)
    setattr(nodes[10].outputs[5], 'name', 'Parametric')
    setattr(nodes[10].outputs[5], 'show_expanded', False)
    setattr(nodes[10].outputs[5], 'type', 'VECTOR')
    setattr(nodes[10].outputs[6], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[10].outputs[6], 'default_value', 0.0)
    setattr(nodes[10].outputs[6], 'enabled', True)
    setattr(nodes[10].outputs[6], 'hide', False)
    setattr(nodes[10].outputs[6], 'hide_value', False)
    setattr(nodes[10].outputs[6], 'link_limit', 4095)
    setattr(nodes[10].outputs[6], 'name', 'Backfacing')
    setattr(nodes[10].outputs[6], 'show_expanded', False)
    setattr(nodes[10].outputs[6], 'type', 'VALUE')
    setattr(nodes[10].outputs[7], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[10].outputs[7], 'default_value', 0.0)
    setattr(nodes[10].outputs[7], 'enabled', True)
    setattr(nodes[10].outputs[7], 'hide', False)
    setattr(nodes[10].outputs[7], 'hide_value', False)
    setattr(nodes[10].outputs[7], 'link_limit', 4095)
    setattr(nodes[10].outputs[7], 'name', 'Pointiness')
    setattr(nodes[10].outputs[7], 'show_expanded', False)
    setattr(nodes[10].outputs[7], 'type', 'VALUE')
    setattr(nodes[11], 'bl_description', '')
    setattr(nodes[11], 'bl_height_default', 100.0)
    setattr(nodes[11], 'bl_height_max', 30.0)
    setattr(nodes[11], 'bl_height_min', 30.0)
    setattr(nodes[11], 'bl_icon', 'NONE')
    setattr(nodes[11], 'bl_idname', 'ShaderNodeMixShader')
    setattr(nodes[11], 'bl_label', 'Mix Shader')
    setattr(nodes[11], 'bl_static_type', 'MIX_SHADER')
    setattr(nodes[11], 'bl_width_default', 140.0)
    setattr(nodes[11], 'bl_width_max', 320.0)
    setattr(nodes[11], 'bl_width_min', 100.0)
    setattr(nodes[11], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[11], 'height', 100.0)
    setattr(nodes[11], 'hide', False)
    setattr(nodes[11], 'label', '')
    setattr(nodes[11], 'location', [-75.35369873046875, 1.8464736938476562])
    setattr(nodes[11], 'mute', False)
    setattr(nodes[11], 'name', 'Mix Shader.003')
    setattr(nodes[11], 'parent', None)
    setattr(nodes[11], 'select', True)
    setattr(nodes[11], 'show_options', True)
    setattr(nodes[11], 'show_preview', False)
    setattr(nodes[11], 'show_texture', False)
    setattr(nodes[11], 'use_custom_color', False)
    setattr(nodes[11], 'width', 140.0)
    setattr(nodes[11], 'width_hidden', 42.0)
    setattr(nodes[11].inputs[0], 'bl_idname', 'NodeSocketFloatFactor')
    setattr(nodes[11].inputs[0], 'default_value', 0.5)
    setattr(nodes[11].inputs[0], 'enabled', True)
    setattr(nodes[11].inputs[0], 'hide', False)
    setattr(nodes[11].inputs[0], 'hide_value', False)
    setattr(nodes[11].inputs[0], 'link_limit', 1)
    setattr(nodes[11].inputs[0], 'name', 'Fac')
    setattr(nodes[11].inputs[0], 'show_expanded', False)
    setattr(nodes[11].inputs[0], 'type', 'VALUE')
    setattr(nodes[11].inputs[1], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[11].inputs[1], 'enabled', True)
    setattr(nodes[11].inputs[1], 'hide', False)
    setattr(nodes[11].inputs[1], 'hide_value', False)
    setattr(nodes[11].inputs[1], 'link_limit', 1)
    setattr(nodes[11].inputs[1], 'name', 'Shader')
    setattr(nodes[11].inputs[1], 'show_expanded', False)
    setattr(nodes[11].inputs[1], 'type', 'SHADER')
    setattr(nodes[11].inputs[2], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[11].inputs[2], 'enabled', True)
    setattr(nodes[11].inputs[2], 'hide', False)
    setattr(nodes[11].inputs[2], 'hide_value', False)
    setattr(nodes[11].inputs[2], 'link_limit', 1)
    setattr(nodes[11].inputs[2], 'name', 'Shader')
    setattr(nodes[11].inputs[2], 'show_expanded', False)
    setattr(nodes[11].inputs[2], 'type', 'SHADER')
    setattr(nodes[11].outputs[0], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[11].outputs[0], 'enabled', True)
    setattr(nodes[11].outputs[0], 'hide', False)
    setattr(nodes[11].outputs[0], 'hide_value', False)
    setattr(nodes[11].outputs[0], 'link_limit', 4095)
    setattr(nodes[11].outputs[0], 'name', 'Shader')
    setattr(nodes[11].outputs[0], 'show_expanded', False)
    setattr(nodes[11].outputs[0], 'type', 'SHADER')
    setattr(nodes[12], 'bl_description', '')
    setattr(nodes[12], 'bl_height_default', 100.0)
    setattr(nodes[12], 'bl_height_max', 30.0)
    setattr(nodes[12], 'bl_height_min', 30.0)
    setattr(nodes[12], 'bl_icon', 'NONE')
    setattr(nodes[12], 'bl_idname', 'ShaderNodeMixShader')
    setattr(nodes[12], 'bl_label', 'Mix Shader')
    setattr(nodes[12], 'bl_static_type', 'MIX_SHADER')
    setattr(nodes[12], 'bl_width_default', 140.0)
    setattr(nodes[12], 'bl_width_max', 320.0)
    setattr(nodes[12], 'bl_width_min', 100.0)
    setattr(nodes[12], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[12], 'height', 100.0)
    setattr(nodes[12], 'hide', False)
    setattr(nodes[12], 'label', '')
    setattr(nodes[12], 'location', [294.03839111328125, 21.681777954101562])
    setattr(nodes[12], 'mute', False)
    setattr(nodes[12], 'name', 'Mix Shader.002')
    setattr(nodes[12], 'parent', None)
    setattr(nodes[12], 'select', True)
    setattr(nodes[12], 'show_options', True)
    setattr(nodes[12], 'show_preview', False)
    setattr(nodes[12], 'show_texture', False)
    setattr(nodes[12], 'use_custom_color', False)
    setattr(nodes[12], 'width', 140.0)
    setattr(nodes[12], 'width_hidden', 42.0)
    setattr(nodes[12].inputs[0], 'bl_idname', 'NodeSocketFloatFactor')
    setattr(nodes[12].inputs[0], 'default_value', 0.5)
    setattr(nodes[12].inputs[0], 'enabled', True)
    setattr(nodes[12].inputs[0], 'hide', False)
    setattr(nodes[12].inputs[0], 'hide_value', False)
    setattr(nodes[12].inputs[0], 'link_limit', 1)
    setattr(nodes[12].inputs[0], 'name', 'Fac')
    setattr(nodes[12].inputs[0], 'show_expanded', False)
    setattr(nodes[12].inputs[0], 'type', 'VALUE')
    setattr(nodes[12].inputs[1], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[12].inputs[1], 'enabled', True)
    setattr(nodes[12].inputs[1], 'hide', False)
    setattr(nodes[12].inputs[1], 'hide_value', False)
    setattr(nodes[12].inputs[1], 'link_limit', 1)
    setattr(nodes[12].inputs[1], 'name', 'Shader')
    setattr(nodes[12].inputs[1], 'show_expanded', False)
    setattr(nodes[12].inputs[1], 'type', 'SHADER')
    setattr(nodes[12].inputs[2], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[12].inputs[2], 'enabled', True)
    setattr(nodes[12].inputs[2], 'hide', False)
    setattr(nodes[12].inputs[2], 'hide_value', False)
    setattr(nodes[12].inputs[2], 'link_limit', 1)
    setattr(nodes[12].inputs[2], 'name', 'Shader')
    setattr(nodes[12].inputs[2], 'show_expanded', False)
    setattr(nodes[12].inputs[2], 'type', 'SHADER')
    setattr(nodes[12].outputs[0], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[12].outputs[0], 'enabled', True)
    setattr(nodes[12].outputs[0], 'hide', False)
    setattr(nodes[12].outputs[0], 'hide_value', False)
    setattr(nodes[12].outputs[0], 'link_limit', 4095)
    setattr(nodes[12].outputs[0], 'name', 'Shader')
    setattr(nodes[12].outputs[0], 'show_expanded', False)
    setattr(nodes[12].outputs[0], 'type', 'SHADER')
    setattr(nodes[13], 'bl_description', '')
    setattr(nodes[13], 'bl_height_default', 100.0)
    setattr(nodes[13], 'bl_height_max', 30.0)
    setattr(nodes[13], 'bl_height_min', 30.0)
    setattr(nodes[13], 'bl_icon', 'NONE')
    setattr(nodes[13], 'bl_idname', 'ShaderNodeBsdfTransparent')
    setattr(nodes[13], 'bl_label', 'Transparent BSDF')
    setattr(nodes[13], 'bl_static_type', 'BSDF_TRANSPARENT')
    setattr(nodes[13], 'bl_width_default', 140.0)
    setattr(nodes[13], 'bl_width_max', 320.0)
    setattr(nodes[13], 'bl_width_min', 100.0)
    setattr(nodes[13], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[13], 'height', 100.0)
    setattr(nodes[13], 'hide', False)
    setattr(nodes[13], 'label', '')
    setattr(nodes[13], 'location', [289.22320556640625, -190.9403839111328])
    setattr(nodes[13], 'mute', False)
    setattr(nodes[13], 'name', 'Transparent BSDF.002')
    setattr(nodes[13], 'parent', None)
    setattr(nodes[13], 'select', True)
    setattr(nodes[13], 'show_options', True)
    setattr(nodes[13], 'show_preview', False)
    setattr(nodes[13], 'show_texture', False)
    setattr(nodes[13], 'use_custom_color', False)
    setattr(nodes[13], 'width', 140.0)
    setattr(nodes[13], 'width_hidden', 42.0)
    setattr(nodes[13].inputs[0], 'bl_idname', 'NodeSocketColor')
    setattr(nodes[13].inputs[0], 'default_value', [1.0, 1.0, 1.0, 1.0])
    setattr(nodes[13].inputs[0], 'enabled', True)
    setattr(nodes[13].inputs[0], 'hide', False)
    setattr(nodes[13].inputs[0], 'hide_value', False)
    setattr(nodes[13].inputs[0], 'link_limit', 1)
    setattr(nodes[13].inputs[0], 'name', 'Color')
    setattr(nodes[13].inputs[0], 'show_expanded', False)
    setattr(nodes[13].inputs[0], 'type', 'RGBA')
    setattr(nodes[13].outputs[0], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[13].outputs[0], 'enabled', True)
    setattr(nodes[13].outputs[0], 'hide', False)
    setattr(nodes[13].outputs[0], 'hide_value', False)
    setattr(nodes[13].outputs[0], 'link_limit', 4095)
    setattr(nodes[13].outputs[0], 'name', 'BSDF')
    setattr(nodes[13].outputs[0], 'show_expanded', False)
    setattr(nodes[13].outputs[0], 'type', 'SHADER')
    setattr(nodes[14], 'bl_description', '')
    setattr(nodes[14], 'bl_height_default', 100.0)
    setattr(nodes[14], 'bl_height_max', 30.0)
    setattr(nodes[14], 'bl_height_min', 30.0)
    setattr(nodes[14], 'bl_icon', 'NONE')
    setattr(nodes[14], 'bl_idname', 'ShaderNodeMixShader')
    setattr(nodes[14], 'bl_label', 'Mix Shader')
    setattr(nodes[14], 'bl_static_type', 'MIX_SHADER')
    setattr(nodes[14], 'bl_width_default', 140.0)
    setattr(nodes[14], 'bl_width_max', 320.0)
    setattr(nodes[14], 'bl_width_min', 100.0)
    setattr(nodes[14], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[14], 'height', 100.0)
    setattr(nodes[14], 'hide', False)
    setattr(nodes[14], 'label', '')
    setattr(nodes[14], 'location', [896.8837280273438, 53.26445007324219])
    setattr(nodes[14], 'mute', False)
    setattr(nodes[14], 'name', 'Mix Shader.005')
    setattr(nodes[14], 'parent', None)
    setattr(nodes[14], 'select', True)
    setattr(nodes[14], 'show_options', True)
    setattr(nodes[14], 'show_preview', False)
    setattr(nodes[14], 'show_texture', False)
    setattr(nodes[14], 'use_custom_color', False)
    setattr(nodes[14], 'width', 140.0)
    setattr(nodes[14], 'width_hidden', 42.0)
    setattr(nodes[14].inputs[0], 'bl_idname', 'NodeSocketFloatFactor')
    setattr(nodes[14].inputs[0], 'default_value', 0.36790913343429565)
    setattr(nodes[14].inputs[0], 'enabled', True)
    setattr(nodes[14].inputs[0], 'hide', False)
    setattr(nodes[14].inputs[0], 'hide_value', False)
    setattr(nodes[14].inputs[0], 'link_limit', 1)
    setattr(nodes[14].inputs[0], 'name', 'Fac')
    setattr(nodes[14].inputs[0], 'show_expanded', False)
    setattr(nodes[14].inputs[0], 'type', 'VALUE')
    setattr(nodes[14].inputs[1], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[14].inputs[1], 'enabled', True)
    setattr(nodes[14].inputs[1], 'hide', False)
    setattr(nodes[14].inputs[1], 'hide_value', False)
    setattr(nodes[14].inputs[1], 'link_limit', 1)
    setattr(nodes[14].inputs[1], 'name', 'Shader')
    setattr(nodes[14].inputs[1], 'show_expanded', False)
    setattr(nodes[14].inputs[1], 'type', 'SHADER')
    setattr(nodes[14].inputs[2], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[14].inputs[2], 'enabled', True)
    setattr(nodes[14].inputs[2], 'hide', False)
    setattr(nodes[14].inputs[2], 'hide_value', False)
    setattr(nodes[14].inputs[2], 'link_limit', 1)
    setattr(nodes[14].inputs[2], 'name', 'Shader')
    setattr(nodes[14].inputs[2], 'show_expanded', False)
    setattr(nodes[14].inputs[2], 'type', 'SHADER')
    setattr(nodes[14].outputs[0], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[14].outputs[0], 'enabled', True)
    setattr(nodes[14].outputs[0], 'hide', False)
    setattr(nodes[14].outputs[0], 'hide_value', False)
    setattr(nodes[14].outputs[0], 'link_limit', 4095)
    setattr(nodes[14].outputs[0], 'name', 'Shader')
    setattr(nodes[14].outputs[0], 'show_expanded', False)
    setattr(nodes[14].outputs[0], 'type', 'SHADER')
    setattr(nodes[15], 'bl_description', '')
    setattr(nodes[15], 'bl_height_default', 100.0)
    setattr(nodes[15], 'bl_height_max', 30.0)
    setattr(nodes[15], 'bl_height_min', 30.0)
    setattr(nodes[15], 'bl_icon', 'NONE')
    setattr(nodes[15], 'bl_idname', 'ShaderNodeEmission')
    setattr(nodes[15], 'bl_label', 'Emission')
    setattr(nodes[15], 'bl_static_type', 'EMISSION')
    setattr(nodes[15], 'bl_width_default', 140.0)
    setattr(nodes[15], 'bl_width_max', 320.0)
    setattr(nodes[15], 'bl_width_min', 100.0)
    setattr(nodes[15], 'color', [0.6079999804496765, 0.6079999804496765, 0.6079999804496765])
    setattr(nodes[15], 'height', 100.0)
    setattr(nodes[15], 'hide', False)
    setattr(nodes[15], 'label', '')
    setattr(nodes[15], 'location', [884.5516967773438, -131.92843627929688])
    setattr(nodes[15], 'mute', False)
    setattr(nodes[15], 'name', 'Emission')
    setattr(nodes[15], 'parent', None)
    setattr(nodes[15], 'select', True)
    setattr(nodes[15], 'show_options', True)
    setattr(nodes[15], 'show_preview', False)
    setattr(nodes[15], 'show_texture', False)
    setattr(nodes[15], 'use_custom_color', False)
    setattr(nodes[15], 'width', 140.0)
    setattr(nodes[15], 'width_hidden', 42.0)
    setattr(nodes[15].inputs[0], 'bl_idname', 'NodeSocketColor')
    setattr(nodes[15].inputs[0], 'default_value', [0.800000011920929, 0.800000011920929, 0.800000011920929, 1.0])
    setattr(nodes[15].inputs[0], 'enabled', True)
    setattr(nodes[15].inputs[0], 'hide', False)
    setattr(nodes[15].inputs[0], 'hide_value', False)
    setattr(nodes[15].inputs[0], 'link_limit', 1)
    setattr(nodes[15].inputs[0], 'name', 'Color')
    setattr(nodes[15].inputs[0], 'show_expanded', False)
    setattr(nodes[15].inputs[0], 'type', 'RGBA')
    setattr(nodes[15].inputs[1], 'bl_idname', 'NodeSocketFloat')
    setattr(nodes[15].inputs[1], 'default_value', 0.25)
    setattr(nodes[15].inputs[1], 'enabled', True)
    setattr(nodes[15].inputs[1], 'hide', False)
    setattr(nodes[15].inputs[1], 'hide_value', False)
    setattr(nodes[15].inputs[1], 'link_limit', 1)
    setattr(nodes[15].inputs[1], 'name', 'Strength')
    setattr(nodes[15].inputs[1], 'show_expanded', False)
    setattr(nodes[15].inputs[1], 'type', 'VALUE')
    setattr(nodes[15].outputs[0], 'bl_idname', 'NodeSocketShader')
    setattr(nodes[15].outputs[0], 'enabled', True)
    setattr(nodes[15].outputs[0], 'hide', False)
    setattr(nodes[15].outputs[0], 'hide_value', False)
    setattr(nodes[15].outputs[0], 'link_limit', 4095)
    setattr(nodes[15].outputs[0], 'name', 'Emission')
    setattr(nodes[15].outputs[0], 'show_expanded', False)
    setattr(nodes[15].outputs[0], 'type', 'SHADER')


print('----------- START ------------')
doIt()
print('DONE')
