/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#include "Runners.h"

#include "utils/CalamaresUtilsSystem.h"
#include "utils/Logger.h"

#include <QFileInfo>
#include <QProcess>
#include <QStandardPaths>

Runner::Runner( const QString& source, const QString& destination )
    : m_source( source )
    , m_destination( destination )
{
}

Runner::~Runner() {}

bool
Runner::checkSourceExists() const
{
    QFileInfo fi( m_source );
    return fi.exists() && fi.isReadable();
}

bool
Runner::checkToolExists( const QString& toolName, QString& fullPath )
{
    fullPath = QStandardPaths::findExecutable( toolName );
    return !fullPath.isEmpty();
}

RunCommand::~RunCommand() {}

void
RunCommand::stdOutReady()
{
    if ( m_process )
    {
        while ( m_process->canReadLine() )
        {
            QString s = m_process->readLine();
            if ( !s.isEmpty() )
            {
                Q_EMIT stdOut( s );
            }
        }
    }
}

Calamares::JobResult
explainProcess( QProcess& process )
{
    if ( process.exitStatus() == QProcess::CrashExit )
    {
        cError() << "Process" << process.program() << "crashed.";
        return CalamaresUtils::ProcessResult::explainProcess(
            process.exitStatus(), process.program(), QString(), std::chrono::seconds( 0 ) );
    }
    if ( process.exitCode() == 0 )
    {

        return Calamares::JobResult::ok();
    }
    else
    {
        cError() << "Process" << process.program() << "returned non-zero exit code, output\n"
                 << process.readAllStandardError();
        return Calamares::JobResult::error( RunCommand::tr( "Command failed" ),
                                            RunCommand::tr( "The <i>%1</i> tool returned error code %2." )
                                                .arg( process.program(), process.exitCode() ) );
    }
}

Calamares::JobResult
RunCommand::run()
{
    QStringList arguments = m_commandLine;
    QString toolName = arguments.takeFirst();

    QProcess process;
    process.setProgram( toolName );
    process.setArguments( arguments );

    m_process = &process;
    connect( &process, &QProcess::readyReadStandardOutput, this, &RunCommand::stdOutReady );

    process.start();
    if ( !process.waitForStarted() )
    {
        return Calamares::JobResult::error( tr( "Command failed" ),
                                            tr( "The <i>%1</i> tool could not be started." ).arg( toolName ) );
    }
    process.waitForFinished();
    process.readAllStandardOutput();  // If there's any cruft left over
    m_process = nullptr;

    return explainProcess( process );
}
