Autodesk Maya - MEL script to batch fix your materials ready for rendering
------------------------------------------------------------------------------

Submitted by cptplutonic

(http://www.reddit.com/r/jmc2obj/comments/smt0d/autodesk_maya_mel_script_to_batch_fix_your/)

Updated by michal121345
Added filtering for Redshift and Arnold file attributes


Instructions
------------

Copy-paste into your MEL script editor in Maya and run it directly or stick it on your shelf.

Maya adds a default quadratic pixel filter to any referenced textures, this results in a blurry 
texture applied to the objects because they are such small resolution. Maya also doesn't import 
transparencies as nicely as Blender, this script automates the process tog et all your textures 
looking nice ready for render.

Make sure you have at least one material selected in Hypershade first. 

As it says:

+Batch remove Pixel Filter: Removes the default pixel filter of the materials' texture. 
Use this on ALL the materials.

+Batch apply Transparency: Attatches the transparency to the selected materials. 
Use ONLY ON MATERIALS THAT REQUIRE TRANSPARENCY.

Hope it helps someone ;)

The script
----------

MainWindow;


global proc MainWindow()
{
    // check first for another instance of this window..
    if((`window -exists "MainWindow"`) == true) {
        // ..if there is, close it
        deleteUI MainWindow;
    }
    // create the window
    createMainWindow("MainWindow");
}

proc createMainWindow(string $name) {

    // set our window sizes
    $windowHeight = 256;
    $windowWidth = 450;

    string $windowName = `window -widthHeight 300 200 -title $name $name`;

    frameLayout -l "jMC2obj Batch Helper" -mh 5 -mw 5;

    columnLayout -adjustableColumn true -columnAttach "both" 10;

    text -label "\nMenu" -align "center";
    separator -height 10;

    // Use on ALL materials in the scene to remove the pixel filter //
    button -label "Batch remove Pixel Filter" -command pixelFilter;
    // Use on TRANSPARENT materials in the scene to attatch transparency //
    button -label "Batch apply Transparency" -command attatchTransparency;

    showWindow $windowName;
}

global proc pixelFilter() {

    string $materials[] = `ls -selection`;

    if ($materials[0] == "") {
        print "//You must select at least one material.\n";        
    }

    else {
        for($material in $materials){
            catch ( `select -r ($material + "F")` );
            catch ( `setAttr ($material + "F.filterType") 0 ` );
            //Arnold Filterfix
            catchQuiet (`setAttr ($material + "F.aiFilter") 0 `);             
            //Redshift Filterfix
            catchQuiet (`setAttr ($material + "F.rsFilterEnable") 0 `); 
        }
    }    
}

global proc attatchTransparency() {   

    string $materials[] = `ls -selection`;

    if ($materials[0] == "") {
        print "//You must select at least one material.\n";        
    }

    else {
        for($material in $materials){
            catch ( `select -r $material`  );    
            catch ( `connectAttr -force ($material + "F.outTransparency") ($material + ".transparency")`  );
        }
    } 
}
