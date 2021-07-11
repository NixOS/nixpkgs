import sys;

initialAssociationFileName = sys.argv[ 1 ]
finalAssociationFileName   = sys.argv[ 2 ]

iaf = open( initialAssociationFileName, 'r' ) ;
initialAssociations = iaf.readlines()
iaf.close();

finalAssociations = []

finalAssociations.append( initialAssociations[ 0 ] )

customAssociationKeys = list( customAssociations.keys() )
customAssociationKeys.sort()

customAssociationIndex = 0;

customMime = customAssociationKeys[ customAssociationIndex ] 
# import pdb; pdb.set_trace()

for i in range( 1, len( initialAssociations ) ):
    initial = initialAssociations[ i ].split( "=" )
    mimetype = initial[0]
    association = initial[1]

    while( customMime < mimetype ):

        finalAssociations.append( 
                customMime + "=" + customAssociations[ customMime ] + ";" 
        )

        customAssociationIndex += 1 
        if customAssociationIndex == len( customAssociations ) : 
            break
        else:
            customMime = customAssociationKeys[ customAssociationIndex ] 

    if( customMime == mimetype ):
        finalAssociations.append(
                mimetype + "=" + customAssociations[ customMime ] + ";" + association 
        )
        customAssociationIndex += 1 
        customMime = customAssociationKeys[ customAssociationIndex ] 
    else:
        finalAssociations.append( initialAssociations[ i ] )

while customAssociationIndex < len( customAssociationKeys ):
    customMime = customAssociationKeys[ customAssociationIndex ] 
    finalAssociations.append( 
            customMime + "=" + customAssociations[ customMime ] + ";" 
    )
    customAssociationIndex += 1 

with open( finalAssociationFileName, 'w') as finalAssociationsFile:
    for i in range( 0, len( finalAssociations ) ):
        finalAssociationsFile.write( finalAssociations[ i ]  )


