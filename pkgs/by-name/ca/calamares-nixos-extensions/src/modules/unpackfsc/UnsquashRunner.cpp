/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#include "UnsquashRunner.h"

#include <utils/Logger.h>
#include <utils/Runner.h>

#include <QString>

static constexpr const int chunk_size = 107;

Calamares::JobResult
UnsquashRunner::run()
{
    if ( !checkSourceExists() )
    {
        return Calamares::JobResult::internalError(
            tr( "Invalid unsquash configuration" ),
            tr( "The source archive <i>%1</i> does not exist." ).arg( m_source ),
            Calamares::JobResult::InvalidConfiguration );
    }

    const QString toolName = QStringLiteral( "unsquashfs" );
    QString unsquashExecutable;
    if ( !checkToolExists( toolName, unsquashExecutable ) )
    {
        return Calamares::JobResult::internalError(
            tr( "Missing tools" ),
            tr( "The <i>%1</i> tool is not installed on the system." ).arg( toolName ),
            Calamares::JobResult::MissingRequirements );
    }

    const QString destinationPath = CalamaresUtils::System::instance()->targetPath( m_destination );
    if ( destinationPath.isEmpty() )
    {
        return Calamares::JobResult::internalError(
            tr( "Invalid unsquash configuration" ),
            tr( "No destination could be found for <i>%1</i>." ).arg( m_destination ),
            Calamares::JobResult::InvalidConfiguration );
    }

    // Get the stats (number of inodes) from the FS
    {
        m_inodes = -1;
        Calamares::Utils::Runner r( { unsquashExecutable, QStringLiteral( "-s" ), m_source } );
        r.setLocation( Calamares::Utils::RunLocation::RunInHost ).enableOutputProcessing();
        QObject::connect( &r, &decltype( r )::output, [&]( QString line ) {
            if ( line.startsWith( "Number of inodes " ) )
            {
                m_inodes = line.split( ' ', Qt::SkipEmptyParts ).last().toInt();
            }
        } );
        /* ignored */ r.run();
    }
    if ( m_inodes <= 0 )
    {
        cWarning() << "No stats could be obtained from" << unsquashExecutable << "-s";
    }

    // Now do the actual unpack
    {
        m_processed = 0;
        Calamares::Utils::Runner r( { unsquashExecutable,
                                      QStringLiteral( "-i" ),  // List files
                                      QStringLiteral( "-f" ),  // Force-overwrite
                                      QStringLiteral( "-d" ),
                                      destinationPath,
                                      m_source } );
        r.setLocation( Calamares::Utils::RunLocation::RunInHost ).enableOutputProcessing();
        connect( &r, &decltype( r )::output, this, &UnsquashRunner::unsquashProgress );
        return r.run().explainProcess( toolName, std::chrono::seconds( 0 ) );
    }
}

void
UnsquashRunner::unsquashProgress( QString line )
{
    m_processed++;
    m_since++;
    if ( m_since > chunk_size && line.contains( '/' ) )
    {
        const QString filename = line.split( '/', Qt::SkipEmptyParts ).last().trimmed();
        if ( !filename.isEmpty() )
        {
            m_since = 0;
            double p = m_inodes > 0 ? ( double( m_processed ) / double( m_inodes ) ) : 0.5;
            Q_EMIT progress( p, tr( "Unsquash file %1" ).arg( filename ) );
        }
    }
}
