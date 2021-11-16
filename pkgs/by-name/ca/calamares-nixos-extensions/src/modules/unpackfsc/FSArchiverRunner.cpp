/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#include "FSArchiverRunner.h"

#include <utils/Logger.h>
#include <utils/Runner.h>

#include <QProcess>


Calamares::JobResult
FSArchiverRunner::run()
{
    const QString toolName = QStringLiteral( "fsarchiver" );

    if ( !checkSourceExists() )
    {
        return Calamares::JobResult::internalError(
            tr( "Invalid fsarchiver configuration" ),
            tr( "The source archive <i>%1</i> does not exist." ).arg( m_source ),
            Calamares::JobResult::InvalidConfiguration );
    }

    QString fsarchiverExecutable;
    if ( !checkToolExists( toolName, fsarchiverExecutable ) )
    {
        return Calamares::JobResult::internalError(
            tr( "Missing tools" ),
            tr( "The <i>%1</i> tool is not installed on the system." ).arg( toolName ),
            Calamares::JobResult::MissingRequirements );
    }

    Calamares::Utils::Runner r( { fsarchiverExecutable,
                                  QStringLiteral( "-v" ),
                                  QStringLiteral( "restfs" ),
                                  m_source,
                                  QStringLiteral( "id=0,dest=%1" ).arg( m_destination ) } );
    r.setLocation( Calamares::Utils::RunLocation::RunInHost ).enableOutputProcessing();
    connect( &r, &decltype( r )::output, this, &FSArchiverRunner::fsarchiverProgress );
    return r.run().explainProcess( toolName, std::chrono::seconds( 0 ) );
}

void
FSArchiverRunner::fsarchiverProgress( QString line )
{
    // Typical line of output is this:
    // -[00][ 99%][REGFILEM] /boot/thing
    //      5   9           ^21
    if (line.length() > 21 && line[5] == '[' && line[9] == '%')
    {
        double p = double(line.mid(6,3).toInt()) / 100.0;
        const QString filename = line.mid(22);
        Q_EMIT progress(p, filename);
    }
}
